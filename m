Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E9D31EE63
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhBRSdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbhBRRvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Feb 2021 12:51:14 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 928B4C061756
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:50:33 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b8so1632435plh.12
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ar4qumgxjcARbIFNPkL/fEc8ffnJvriNV7C8I9UZSSE=;
        b=o9eKOmDlEvLgF6YUJdS59NPQ8hR9UNjLOg6pdh1fOYz7oj26RjNd0/gdCyvhR16Ss/
         QEcxfxRP6GOdmQy214V4gKyYY4uKZib7/caSaZpMfA6vAEL6fSnN4J+vdISK4TJG9wZD
         thU6v9SnWg7mQLwZgyRSZptilY/oodJWLDHejowBBpAdZAvass3h+C5x4P9eYuzOrt1j
         DVGR5cLo9uSbG9yZjLiReEyaxEacNfhi9lV/sBvAJenk1S7uAh3hIFzCk9AyRtxwiiZo
         h0vkp8pTMfBjQWGQVsaqHh8ooO21nVhiEy32WU6TRpte+qrTgd5ihTtAxqPoRc/nqJK3
         CMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ar4qumgxjcARbIFNPkL/fEc8ffnJvriNV7C8I9UZSSE=;
        b=DgJYH5Lh9f85OH9BTQ3Qs8rWy5Udg4YQZo5zp2FFmHCpN59sVLpz7GXJmza7a0y62N
         RzJOXORNERE8H87XgT5ixd8Y/1ere4H8pyc72paKkn9heyjbEtDc9+ttstmaHgR1TwB5
         0vchOpsIIUtkkdRIpYv+yg6rBsOd4VP0WPM148mEW577Y3NCUfEZkloPYqJU6m8+f/GZ
         nzEzyUaie3m/PKELGnCp/l6l/vL+qP434gnbAP3HckPOto/YKls9hLv6PVScbQYnKSqX
         BIkm7qAv1vhiiE2tz4H5MyeIqxuqrHppBWXdb+hlNXTa3iCKbPUsujccyK0flMFAftV9
         hNKw==
X-Gm-Message-State: AOAM531vUpTMQRmwpx3KPC+FGZ81/kSman4+ZujUGD73XGyzPZAkxvea
        /gHyfl9r+AkwisV8+MwGp+XSUQ==
X-Google-Smtp-Source: ABdhPJxae0TGH4xiwe5Lj9mlTgbQqTEgLNrW6Vk+Pi9f/XdUSadjneFfcPUzbsnvAzsiXDlRBwG2hw==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr4926719pjb.29.1613670632785;
        Thu, 18 Feb 2021 09:50:32 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id 6sm6451766pgv.70.2021.02.18.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 09:50:32 -0800 (PST)
Date:   Thu, 18 Feb 2021 09:50:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YC6o4YwTAOU7UE1u@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YC1AkNPNET+T928c@google.com>
 <SN6PR12MB27676C0BF3BBA872E55D5FC78E859@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YC6YOuJyNlSxKVR4@google.com>
 <SN6PR12MB2767A978C3A2B43982F2F4898E859@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB2767A978C3A2B43982F2F4898E859@SN6PR12MB2767.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 18, 2021, Kalra, Ashish wrote:
> From: Sean Christopherson <seanjc@google.com> 
> 
> On Thu, Feb 18, 2021, Kalra, Ashish wrote:
> > From: Sean Christopherson <seanjc@google.com>
> > 
> > On Wed, Feb 17, 2021, Kalra, Ashish wrote:
> > >> From: Sean Christopherson <seanjc@google.com> On Thu, Feb 04, 2021, 
> > >> Ashish Kalra wrote:
> > >> > From: Brijesh Singh <brijesh.singh@amd.com>
> > >> > 
> > >> > The ioctl is used to retrieve a guest's shared pages list.
> > >> 
> > >> >What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS 
> > >> >is passed through to userspace?  That way, userspace could manage 
> > >> >the set of pages >in whatever data structure they want, and these get/set ioctls go away.
> > >> 
> > >> What is the advantage of passing KVM_HC_PAGE_ENC_STATUS through to 
> > >> user-space ?
> > >> 
> > >> As such it is just a simple interface to get the shared page list 
> > >> via the get/set ioctl's. simply an array is passed to these ioctl 
> > >> to get/set the shared pages list.
> >> 
> >> > It eliminates any probability of the kernel choosing the wrong data 
> >> > structure, and it's two fewer ioctls to maintain and test.
> >> 
> >> The set shared pages list ioctl cannot be avoided as it needs to be 
> >> issued to setup the shared pages list on the migrated VM, it cannot be 
> >> achieved by passing KVM_HC_PAGE_ENC_STATUS through to user-space.
> 
> >Why's that?  AIUI, KVM doesn't do anything with the list other than pass it
> >back to userspace.  Assuming that's the case, userspace can just hold onto
> >the list >for the next migration.
> 
> KVM does use it as part of the SEV DBG_DECTYPT API, within sev_dbg_decrypt()
> to check if the guest page(s) are encrypted or not, and accordingly use it to
> decide whether to decrypt the guest page(s) and return that back to
> user-space or just return it as it is.

Why is handling shared memory KVM's responsibility?  Userspace shouldn't be
asking KVM to decrypt memory it knows isn't encrypted.  My understanding is that
bogus decryption won't harm the kernel, it will only corrupt the guest.  In
other words, patch 16 can be dropped if managing the set of shared pages is
punted to userspace.
