Return-Path: <kvm+bounces-63625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 57839C6C0C4
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6B0333530A5
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72DE2FC02D;
	Tue, 18 Nov 2025 23:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="W0Udr05j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180A72DAFAE
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763509717; cv=none; b=RogxqsCtb0BPuOwhDN5V91PFcLXIBb7upzcTPI0mkqhvkg8jb5s3wL7ai3oTVF0nd5U4uHK2nkyiWEGUgTcFTa/HY1oH5aGwQ1Ms18ynhkMAumDLJht4htC2HuajL9Vg7nlqEidDTtw0JOjIiJgk9ZM2tOo5B4oGCwvSVtnHbZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763509717; c=relaxed/simple;
	bh=bGJa3jIZt8FGUtG8xMgQ/fGulIZYE1CTdUfSMswqGe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9rxgCp/tHQHJ2+doWL/gZAej6sgjU62Q/5DEfwCZ3W++jkiyc7saMJ6RBWKEC7iGJCkNctyjEu5RLUkmOuNlY/BcjwEaQ6hwKMoEhtDcLUktct/2dZ0JonYWqODPW6iayIMWS+Sa55PWfhpOBRKzlI2sC3gcV2w2vRRMrCYaRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=W0Udr05j; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-340ad724ea4so1004375a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1763509715; x=1764114515; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g9o48bCDZVKz4wWNAEWd+3hnVNOYOis99bHGZNu+T7s=;
        b=W0Udr05jm+oeWNqPFZHA3H5pDvFc4+DbRDmF6NKnwa9mO1HpcvIcCwzTIcFejIS2/Y
         sBg0fj6PBN5LqLt2R+cnr4AZNglH7lWKYufHKivIqq+2C8Bp3CgMwwiEWlfGRGEnEeWf
         KBpkceDnjJ7hwkHrb87/j1BKTv7kWoje/zIK6bXXdUFSt+VM+nKd2hzZnZe9NUO0/O76
         sXFjvSgkc1kZGVh3BaSUDZRAtirUXf8LOt4eegH8HvxiyzsLWxz01WK9mIbSuwaOAD7z
         BvGQVRZqT/RHVjTNmHifR6A1mDwP7hr+yR6pubSS5HCZoqaeExXZqPangg9MGKjomAB5
         SfoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763509715; x=1764114515;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9o48bCDZVKz4wWNAEWd+3hnVNOYOis99bHGZNu+T7s=;
        b=aDUTFydcT82j6fH+67im/Z91NC8/wMg+0aMCIn3PzMmG5UddhYGYI2T/DEd9oNpv7V
         6Hz0AdIoThHYuH8x4645abaXU6Ru6qHdBYs8DoZ4QHtsDp6DbKbOv24MNh6O96otxWwD
         Q5Z0qenWwcb9yEYjupStTuyS3vNFhaKevkJQk3T8ErHUVhN0qVfoQccH5zOZyVj4k7YI
         EWV2DKtHkm+UkgO3GucTnQ7bzp0nmU5+HKUfwkq7n0HBQejh3yGYkAGW2+8sRN7hb6fU
         HGrPZcrZFH1zSj3St0xhzdDYvQYbAFD7h+qRf98ezCnsWvEBBgiApO3OJ+hehbxQhKm1
         4DAg==
X-Forwarded-Encrypted: i=1; AJvYcCWTsSFtaVZdYgvxgQLVkd7y8ruNKejNA+FksLmNdlsG5ogEiqsfZTKGBl8/c5TkwOdWYSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx57dgI36nPbKH3jNrwgJh0mc/JE1kPgEgcDan48aGY9/81BwaL
	oNO3zJenmR+laPSpKJOzXkIQEhZ/UqzhMbiW2RM/2k8hgp4WI3n617STXg1999Nds9M=
X-Gm-Gg: ASbGncvnxQ66DTpHPabdcPKKnMghX14XS7XD8Fi5j1HSPMSvRnlMKnR7P2WIeAqaHBo
	vQXX1TAjGpyicMspEE/7VZVdezy6Uro/4ThCzBArgN1twCNjKtpysYcmEeIAaudWKgGsanV1NF2
	2cl7d3Lb1COYL3FRK4Tz4x0hWVLRbm5HuwqT8HpadX8fk4fA9s5FEs9OPp9OZdiis9ifVmWnDbE
	a78JfTTzT1klZ88sQyKRUhbSWXEFzMTSopT7rAAjMo7zkZiWhJ44rNH9bBsiKxhrmoMimnxLKe7
	Vloy4iPBhD2Kep4JgOYv6VbvOrfEwDZhvN586+KWEB+dipVLAzvPawcgTjTKyJZL5+ehN35W+Aj
	NPris1rzIU/2GrTbAe0+111itl4d7PgGAvXHyShT/Z8tvYt5EL64PyTXxoFxagDeLgp+q2MvNXV
	oWLOV9N4GP6yNVypPX9EVoBeu90vUz7cIstC8=
X-Google-Smtp-Source: AGHT+IGFvaMnr1ypTwY4htD/E/7DrqomMERWBIRui56XAe3+nBWn0Awu23JdYIsYLO6obfjEpHmkRQ==
X-Received: by 2002:a17:90b:4d87:b0:341:88ba:c632 with SMTP id 98e67ed59e1d1-343f99dade7mr11078480a91.0.1763509715326;
        Tue, 18 Nov 2025 15:48:35 -0800 (PST)
Received: from telecaster ([2601:602:9200:4a00::ec1a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc37507fc7bsm16363525a12.23.2025.11.18.15.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 15:48:34 -0800 (PST)
Date: Tue, 18 Nov 2025 15:48:34 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Subject: Re: [PATCH v3] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
Message-ID: <aR0F0vHdn5MllADe@telecaster>
References: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
 <aRzg-3XWu7nM5yWS@telecaster>
 <aR0CSrJ1u1vFSYZZ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aR0CSrJ1u1vFSYZZ@google.com>

On Tue, Nov 18, 2025 at 03:33:30PM -0800, Sean Christopherson wrote:
> On Tue, Nov 18, 2025, Omar Sandoval wrote:
> > On Tue, Nov 04, 2025 at 09:55:26AM -0800, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > > 
> > > When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
> > > instruction, discard the exception and retry the instruction if the code
> > > stream is changed (e.g. by a different vCPU) between when the CPU
> > > executes the instruction and when KVM decodes the instruction to get the
> > > next RIP.
> > > 
> > > As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
> > > INT3/INTO instead of retrying the instruction"), failure to verify that
> > > the correct INTn instruction was decoded can effectively clobber guest
> > > state due to decoding the wrong instruction and thus specifying the
> > > wrong next RIP.
> > > 
> > > The bug most often manifests as "Oops: int3" panics on static branch
> > > checks in Linux guests.  Enabling or disabling a static branch in Linux
> > > uses the kernel's "text poke" code patching mechanism.  To modify code
> > > while other CPUs may be executing that code, Linux (temporarily)
> > > replaces the first byte of the original instruction with an int3 (opcode
> > > 0xcc), then patches in the new code stream except for the first byte,
> > > and finally replaces the int3 with the first byte of the new code
> > > stream.  If a CPU hits the int3, i.e. executes the code while it's being
> > > modified, then the guest kernel must look up the RIP to determine how to
> > > handle the #BP, e.g. by emulating the new instruction.  If the RIP is
> > > incorrect, then this lookup fails and the guest kernel panics.
> > > 
> > > The bug reproduces almost instantly by hacking the guest kernel to
> > > repeatedly check a static branch[1] while running a drgn script[2] on
> > > the host to constantly swap out the memory containing the guest's TSS.
> > > 
> > > [1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
> > > [2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b
> > > 
> > > Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
> > > Cc: stable@vger.kernel.org
> > > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Omar Sandoval <osandov@fb.com>
> > > ---
> > > Changes from v2 (https://lore.kernel.org/all/6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com/):
> > > 
> > > - Fixed EMULTYPE_SET_SOFT_INT_VECTOR -> EMULTYPE_GET_SOFT_INT_VECTOR
> > >   typo.
> > > - Added explicit u32 cast to EMULTYPE_SET_SOFT_INT_VECTOR to make it
> > >   clear that it won't overflow.
> > > - Rebased on Linus's tree as of c9cfc122f03711a5124b4aafab3211cf4d35a2ac.
> > > 
> > >  arch/x86/include/asm/kvm_host.h |  9 +++++++++
> > >  arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
> > >  arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
> > >  3 files changed, 43 insertions(+), 11 deletions(-)
> > 
> > Ping, does this need any more updates?
> 
> For the record, I had this applied and tested before the ping, I just hadn't sent
> the "thank you" yet.  :-D
> 
> commit 4da3768e1820cf15cced390242d8789aed34f54d
> Author:     Omar Sandoval <osandov@fb.com>
> AuthorDate: Tue Nov 4 09:55:26 2025 -0800
> Commit:     Sean Christopherson <seanjc@google.com>
> CommitDate: Thu Nov 13 13:03:19 2025 -0800  <======= See, I'm not lying!

No worries, and thanks! I checked
git://git.kernel.org/pub/scm/virt/kvm/kvm.git before pinging, but not
https://github.com/kvm-x86/linux. I appreciate the help with this!

Omar

