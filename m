Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50505A1D50
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 01:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiHYXni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 19:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244614AbiHYXnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 19:43:33 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E5B8A62
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:43:32 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p18so151700plr.8
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 16:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=CrkUDi4mYcC3qOEbpgTO1y4xAYzFYl9qfJxBFAO1WQU=;
        b=oH89fuC7/OCch4BVe3RICsoOXGZYywI31GBVdOyyzkOO7DEQwz0A3bC8XVXdtvCwd1
         6++QpYTFdw9m4hHnWiKtTIpB7Hi5ELfJeZuqNN9uFKSo7WfdJ9G1Mhm4JK6AV2WHzXjJ
         VbNzkpdmEXJLIC2dBL9fBoXXr3+4Uapf2ay+q5o5OiTRLYNgKYonwB+ySRb6B5oDeL1+
         dAGtJD3OxzwN4u/yHADk0FqkEVYKITXRoFTnTIyXKBO0WL66kWEVFTEfNMRKnT8HVrqd
         r0phSuI2WdqgmUZxadQTwthKDt4ZrV+UeAwXIY6ktT0Ll4TYsN0WDJRL1/UrY3DGWEjg
         ExLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=CrkUDi4mYcC3qOEbpgTO1y4xAYzFYl9qfJxBFAO1WQU=;
        b=ttCyIlWMrjnyRij9/sRQBNXzk9tVHKvb2r96oRI/Dqm7ZPFaPZIYOIlhQDUzVT4H4L
         dAtsXcdaifOCFjX3lxKR7iQqrECIyGNBiwGwcxYarI9QfBsaHC4W8BVeN9jnWDEKxpf6
         c7vHHymaIwvaEpOSiZxCqVFL5r7BYEy69MpMu4VMuPkBPRtlPy8OfK2gqRkqp7ZcQChp
         FRIH1+zFgEjwLV5w81ETQL8tAmBko9byggIb1bWevZBIywqMGLmNlLdrit0Xc7QEMtya
         mf8a8NCnlTqqn7faSTV+mgzy05FR+lMELnpeotZdfK/YmeTObsZWsZ3ts/nydVNiL5xy
         13DA==
X-Gm-Message-State: ACgBeo0KKjhb4iBMKtacOnoDef2HtrvQ0R6NlH9Xp5SETIER5Lt44mmR
        HyGzIJcj0TfeXwKqQMyG+loYmg==
X-Google-Smtp-Source: AA6agR7uDYeONp1wM5VEYWT/Ep3xp8EiV6yvT/4U8QUXuA4MqoQg5QOZ3aLyR1Qey0199Sw+p/pMAg==
X-Received: by 2002:a17:90b:2390:b0:1fa:c680:1f63 with SMTP id mr16-20020a17090b239000b001fac6801f63mr1464578pjb.16.1661471012094;
        Thu, 25 Aug 2022 16:43:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a9-20020aa78e89000000b005379fb50ff0sm216131pfr.50.2022.08.25.16.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:43:31 -0700 (PDT)
Date:   Thu, 25 Aug 2022 23:43:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com, aarcange@redhat.com,
        ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com
Subject: Re: [PATCH v6 6/8] KVM: Handle page fault for private memory
Message-ID: <YwgJH0TRZO4ie4z8@google.com>
References: <20220519153713.819591-1-chao.p.peng@linux.intel.com>
 <20220519153713.819591-7-chao.p.peng@linux.intel.com>
 <YqzyjZnflCMPo8b/@google.com>
 <20220819004018.mgdvxhl6dj3ujl3f@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819004018.mgdvxhl6dj3ujl3f@box.shutemov.name>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Kirill A. Shutemov wrote:
> On Fri, Jun 17, 2022 at 09:30:53PM +0000, Sean Christopherson wrote:
> > > @@ -4088,7 +4144,12 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> > >  		read_unlock(&vcpu->kvm->mmu_lock);
> > >  	else
> > >  		write_unlock(&vcpu->kvm->mmu_lock);
> > > -	kvm_release_pfn_clean(fault->pfn);
> > > +
> > > +	if (fault->is_private)
> > > +		kvm_private_mem_put_pfn(fault->slot, fault->pfn);
> > 
> > Why does the shmem path lock the page, and then unlock it here?
> 
> Lock is require to avoid race with truncate / punch hole. Like if truncate
> happens after get_pfn(), but before it gets into SEPT we are screwed.

Getting the PFN into the SPTE doesn't provide protection in and of itself.  The
protection against truncation and whatnot comes from KVM getting a notification
and either retrying the fault (notification acquires mmu_lock before
direct_page_fault()), or blocking the notification (truncate / punch hole) until
after KVM installs the SPTE.  I.e. KVM just needs to ensure it doesn't install a
SPTE _after_ getting notified.

If the API is similar to gup(), i.e. only elevates the refcount but doesn't lock
the page, then there's no need for a separate kvm_private_mem_put_pfn(), and in
fact no need for ->put_unlock_pfn() because can KVM do set_page_dirty() and
put_page() directly as needed using all of KVM's existing mechanisms.
