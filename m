Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9302F601F
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2019 16:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfKIPt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Nov 2019 10:49:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfKIPt4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Nov 2019 10:49:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A25C121848;
        Sat,  9 Nov 2019 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573314595;
        bh=sbzOTfC1vnyLazJ/1JUjHBfVrxtQ75rkBZ4xG9tQRIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R5AE/DXlBIjdMB4iZQrGtBv2p1VP2HICSbqgWuxzMUszxN2cj7h78KwVUSsMsxM07
         9275R9jxjM4+3RNFYoVbZnMNdd9ZOrbCqUy8qv9BU5ffvf3ZpR8VXPByJSJf1hG3D1
         6RTL8u9ZBhyOihuk9eiiw3X3mMtRwTBGfgEd6yvg=
Date:   Sat, 9 Nov 2019 16:49:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: "statsfs" API design
Message-ID: <20191109154952.GA1365674@kroah.com>
References: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 06, 2019 at 04:56:25PM +0100, Paolo Bonzini wrote:
> Hi all,
> 
> statsfs is a proposal for a new Linux kernel synthetic filesystem, to be
> mounted in /sys/kernel/stats, which exposes subsystem-level statistics
> in sysfs.  Reading need not be particularly lightweight, but writing
> must be fast.  Therefore, statistics are gathered at a fine-grain level
> in order to avoid locking or atomic operations, and then aggregated by
> statsfs until the desired granularity.

Wait, reading a statistic from userspace can be slow, but writing to it
from userspace has to be fast?  Or do you mean the speed is all for
reading/writing the value within the kernel?

> The first user of statsfs would be KVM, which is currently exposing its
> stats in debugfs.  However, debugfs access is now limited by the
> security lock down patches, and in addition statsfs aims to be a
> more-or-less stable API, hence the idea of making it a separate
> filesystem and mount point.

Nice, I've had people ask about something like this for a while now.
For the most part they just dump stuff in sysfs instead (see the DRM
patches recently for people attempting to do that for debugfs values as
well.)

> A few people have already expressed interest in this.  Christian
> Borntraeger presented on the kvm_stat tool recently at KVM Forum and was
> also thinking about using some high-level API in debugfs.  Google has
> KVM patches to gather statistics in a binary format; it may be useful to
> add this kind of functionality (and some kind of introspection similar
> to what tracing does) to statsfs too in the future, but this is
> independent from the kernel API.  I'm also CCing Alex Williamson, in
> case VFIO is interested in something similar, and Steven Rostedt because
> apparently he has enough free time to write poetry in addition to code.
> 
> There are just two concepts in statsfs, namely "values" (aka files) and
> "sources" (directories).
> 
> A value represents a single quantity that is gathered by the statsfs
> client.  It could be the number of vmexits of a given kind, the amount
> of memory used by some data structure, the length of the longest hash
> table chain, or anything like that.
> 
> Values are described by a struct like this one:
> 
> 	struct statsfs_value {
> 		const char *name;
> 		enum stat_type type;	/* STAT_TYPE_{BOOL,U64,...} */
> 		u16 aggr_kind;		/* Bitmask with zero or more of
> 					 * STAT_AGGR_{MIN,MAX,SUM,...}
> 					 */
> 		u16 mode;		/* File mode */
> 		int offset;		/* Offset from base address
> 					 * to field containing the value
> 					 */
> 	};
> 
> As you can see, values are basically integers stored somewhere in a
> struct.   The statsfs_value struct also includes information on which
> operations (for example sum, min, max, average, count nonzero) it makes
> sense to expose when the values are aggregated.

What can userspace do with that info?

> Sources form the bulk of the statsfs API.  They can include two kinds of
> elements:
> 
> - values as described above.  The common case is to have many values
> with the same base address, which are represented by an array of struct
> statsfs_value
> 
> - subordinate sources
> 
> Adding a subordinate source has two effects:
> 
> - it creates a subdirectory for each subordinate source
> 
> - for each value in the subordinate sources which has aggr_kind != 0,
> corresponding values will be created in the parent directory too.  If
> multiple subordinate sources are backed by the same array of struct
> statsfs_value, values from all those sources will be aggregated.  That
> is, statsfs will compute these from the values of all items in the list
> and show them in the parent directory.
> 
> Writable values can only be written with a value of zero. Writing zero
> to an aggregate zeroes all the corresponding values in the subordinate
> sources.
> 
> Sources are manipulated with these four functions:
> 
> 	struct statsfs_source *statsfs_source_create(const char *fmt,
> 						     ...);
> 	void statsfs_source_add_values(struct statsfs_source *source,
> 				       struct statsfs_value *stat,
> 				       int n, void *ptr);
> 	void statsfs_source_add_subordinate(
> 					struct statsfs_source *source,
> 					struct statsfs_source *sub);
> 	void statsfs_source_remove_subordinate(
> 					struct statsfs_source *source,
> 					struct statsfs_source *sub);
> 
> Sources are reference counted, and for this reason there is also a pair
> of functions in the usual style:
> 
> 	void statsfs_source_get(struct statsfs_source *);
> 	void statsfs_source_put(struct statsfs_source *);
> 
> Finally,
> 
> 	void statsfs_source_register(struct statsfs_source *source);
> 
> lets you create a toplevel statsfs directory.
> 
> As a practical example, KVM's usage of debugfs could be replaced by
> something like this:
> 
> /* Globals */
> 	struct statsfs_value vcpu_stats[] = ...;
> 	struct statsfs_value vm_stats[] = ...;
> 	static struct statsfs_source *kvm_source;
> 
> /* On module creation */
> 	kvm_source = statsfs_source_create("kvm");
> 	statsfs_source_register(kvm_source);
> 
> /* On VM creation */
> 	kvm->src = statsfs_source_create("%d-%d\n",
> 				         task_pid_nr(current), fd);
> 	statsfs_source_add_values(kvm->src, vm_stats,
> 				  ARRAY_SIZE(vm_stats),
> 				  &kvm->stats);
> 	statsfs_source_add_subordinate(kvm_source, kvm->src);
> 
> /* On vCPU creation */
> 	vcpu_src = statsfs_source_create("vcpu%d\n", vcpu->vcpu_id);
> 	statsfs_source_add_values(vcpu_src, vcpu_stats,
> 				  ARRAY_SIZE(vcpu_stats),
> 				  &vcpu->stats);
> 	statsfs_source_add_subordinate(kvm->src, vcpu_src);
> 	/*
> 	 * No need to keep the vcpu_src around since there's no
> 	 * separate vCPU deletion event; rely on refcount
> 	 * exclusively.
> 	 */
> 	statsfs_source_put(vcpu_src);
> 
> /* On VM deletion */
> 	statsfs_source_remove_subordinate(kvm_source, kvm->src);
> 	statsfs_source_put(kvm->src);
> 
> /* On KVM exit */
> 	statsfs_source_put(kvm_source);
> 
> How does this look?

Where does the actual values get changed that get reflected in the
filesystem?

I have some old notes somewhere about what people really want when it
comes to a good "statistics" datatype, that I was thinking of building
off of, but that seems independant of what you are doing here, right?
This is just exporting existing values to userspace in a semi-sane way?

Anyway, I like the idea, but what about how this is exposed to
userspace?  The criticism of sysfs for statistics is that it is too slow
to open/read/close lots of files and tough to get "at this moment in
time these are all the different values" snapshots easily.  How will
this be addressed here?

thanks,

greg k-h
