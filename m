Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBEF1A82
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 16:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732127AbfKFP4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 10:56:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732066AbfKFP43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 10:56:29 -0500
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9EBE64E8B8
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 15:56:28 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id m17so14324991wrb.20
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 07:56:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:openpgp:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=adnAFhGiXiXMI1/JdENa+YHqmjAgGKvDDZ+BBbEYKBw=;
        b=BT9YBXSRlw+/i4VDRI9jCXh4jc9SfvlThtQa8lPQ3trMetO5gf32Z/Nh6c1koTkrl3
         Jb/zldpk3a9nd9MmWK809Z5oJE/TVwe+UY/oka5glHrwwVkbki4llaRm+XgslvxbykdA
         TRw2EUPdr71zfHLjdHC7yp8fchO1SJwyfHqBSgza0RHrqNNDFmDUJwZ2q6h9cdeaYGZz
         2FElx3aPdrY8vLK34N2CGSNCp/FHDrZhUyX8QktkmKMr9bMZKEclnqHcE+gP28EvxpP4
         EU1qzU7fpfl/V7aRWVs+lI/NM6EA5NXxeqDeJMPN0j36YYuCGh/QFuc5WT3//sldusAa
         1ZUQ==
X-Gm-Message-State: APjAAAU1d8vlgb8hwT0T1ZCUbKn69Dr+DhfqxKg+6yrS5otZlH0SQ4Un
        6wazo170OnMrtwZ1NVWYJ9rBgWTww+RY9cmfUHyKiLpSef2GYeBn2X+/cCmLVCoA9IzrhrMByI0
        jaLM0l+mr2mD0
X-Received: by 2002:adf:e747:: with SMTP id c7mr3345854wrn.384.1573055787160;
        Wed, 06 Nov 2019 07:56:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKBaPCeFoVmwA2ST7J6MvuQIUzl8uWwWIGuEvX483jWqFdwyKqjtdJNCbdHJtF6kF87RjQFQ==
X-Received: by 2002:adf:e747:: with SMTP id c7mr3345813wrn.384.1573055786805;
        Wed, 06 Nov 2019 07:56:26 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:4051:461:136e:3f74? ([2001:b07:6468:f312:4051:461:136e:3f74])
        by smtp.gmail.com with ESMTPSA id w81sm3783002wmg.5.2019.11.06.07.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 07:56:26 -0800 (PST)
To:     KVM list <kvm@vger.kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Subject: "statsfs" API design
Message-ID: <5d6cdcb1-d8ad-7ae6-7351-3544e2fa366d@redhat.com>
Date:   Wed, 6 Nov 2019 16:56:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

statsfs is a proposal for a new Linux kernel synthetic filesystem, to be
mounted in /sys/kernel/stats, which exposes subsystem-level statistics
in sysfs.  Reading need not be particularly lightweight, but writing
must be fast.  Therefore, statistics are gathered at a fine-grain level
in order to avoid locking or atomic operations, and then aggregated by
statsfs until the desired granularity.

The first user of statsfs would be KVM, which is currently exposing its
stats in debugfs.  However, debugfs access is now limited by the
security lock down patches, and in addition statsfs aims to be a
more-or-less stable API, hence the idea of making it a separate
filesystem and mount point.

A few people have already expressed interest in this.  Christian
Borntraeger presented on the kvm_stat tool recently at KVM Forum and was
also thinking about using some high-level API in debugfs.  Google has
KVM patches to gather statistics in a binary format; it may be useful to
add this kind of functionality (and some kind of introspection similar
to what tracing does) to statsfs too in the future, but this is
independent from the kernel API.  I'm also CCing Alex Williamson, in
case VFIO is interested in something similar, and Steven Rostedt because
apparently he has enough free time to write poetry in addition to code.

There are just two concepts in statsfs, namely "values" (aka files) and
"sources" (directories).

A value represents a single quantity that is gathered by the statsfs
client.  It could be the number of vmexits of a given kind, the amount
of memory used by some data structure, the length of the longest hash
table chain, or anything like that.

Values are described by a struct like this one:

	struct statsfs_value {
		const char *name;
		enum stat_type type;	/* STAT_TYPE_{BOOL,U64,...} */
		u16 aggr_kind;		/* Bitmask with zero or more of
					 * STAT_AGGR_{MIN,MAX,SUM,...}
					 */
		u16 mode;		/* File mode */
		int offset;		/* Offset from base address
					 * to field containing the value
					 */
	};

As you can see, values are basically integers stored somewhere in a
struct.   The statsfs_value struct also includes information on which
operations (for example sum, min, max, average, count nonzero) it makes
sense to expose when the values are aggregated.

Sources form the bulk of the statsfs API.  They can include two kinds of
elements:

- values as described above.  The common case is to have many values
with the same base address, which are represented by an array of struct
statsfs_value

- subordinate sources

Adding a subordinate source has two effects:

- it creates a subdirectory for each subordinate source

- for each value in the subordinate sources which has aggr_kind != 0,
corresponding values will be created in the parent directory too.  If
multiple subordinate sources are backed by the same array of struct
statsfs_value, values from all those sources will be aggregated.  That
is, statsfs will compute these from the values of all items in the list
and show them in the parent directory.

Writable values can only be written with a value of zero. Writing zero
to an aggregate zeroes all the corresponding values in the subordinate
sources.

Sources are manipulated with these four functions:

	struct statsfs_source *statsfs_source_create(const char *fmt,
						     ...);
	void statsfs_source_add_values(struct statsfs_source *source,
				       struct statsfs_value *stat,
				       int n, void *ptr);
	void statsfs_source_add_subordinate(
					struct statsfs_source *source,
					struct statsfs_source *sub);
	void statsfs_source_remove_subordinate(
					struct statsfs_source *source,
					struct statsfs_source *sub);

Sources are reference counted, and for this reason there is also a pair
of functions in the usual style:

	void statsfs_source_get(struct statsfs_source *);
	void statsfs_source_put(struct statsfs_source *);

Finally,

	void statsfs_source_register(struct statsfs_source *source);

lets you create a toplevel statsfs directory.

As a practical example, KVM's usage of debugfs could be replaced by
something like this:

/* Globals */
	struct statsfs_value vcpu_stats[] = ...;
	struct statsfs_value vm_stats[] = ...;
	static struct statsfs_source *kvm_source;

/* On module creation */
	kvm_source = statsfs_source_create("kvm");
	statsfs_source_register(kvm_source);

/* On VM creation */
	kvm->src = statsfs_source_create("%d-%d\n",
				         task_pid_nr(current), fd);
	statsfs_source_add_values(kvm->src, vm_stats,
				  ARRAY_SIZE(vm_stats),
				  &kvm->stats);
	statsfs_source_add_subordinate(kvm_source, kvm->src);

/* On vCPU creation */
	vcpu_src = statsfs_source_create("vcpu%d\n", vcpu->vcpu_id);
	statsfs_source_add_values(vcpu_src, vcpu_stats,
				  ARRAY_SIZE(vcpu_stats),
				  &vcpu->stats);
	statsfs_source_add_subordinate(kvm->src, vcpu_src);
	/*
	 * No need to keep the vcpu_src around since there's no
	 * separate vCPU deletion event; rely on refcount
	 * exclusively.
	 */
	statsfs_source_put(vcpu_src);

/* On VM deletion */
	statsfs_source_remove_subordinate(kvm_source, kvm->src);
	statsfs_source_put(kvm->src);

/* On KVM exit */
	statsfs_source_put(kvm_source);

How does this look?

Paolo
