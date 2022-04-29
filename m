Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB98C51513B
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 19:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379368AbiD2RES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 13:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358853AbiD2RER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 13:04:17 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8274D9FC
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:00:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bd19-20020a17090b0b9300b001d98af6dcd1so11028356pjb.4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 10:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9p9eVD7iEikBC4jxuapL3VYhAWQBtz27pVnAlOGf5zE=;
        b=fzyXgX/Hvc4RANCjLs/z+2QFceApoWrIuJrLyV+Ogz+4rJYaG8ih8IKOKjKHHza6+K
         1ynm/CiyQSgcS6fIHCjrXSX0OJPpf90YOogGOeKMf7/5qnJEbMVhPD8S74sLbDif7sVi
         vFd1Zi4PDIOBfiRf0nWsGQf9xHRUCz+pSxAtsvbgpyqauE69sgNYeQL/VVUQYDhALLhA
         KuA5yY6OIy7QNF0q2GCaKDqaJmEg4Iyk0bHQmx4tUnQEGhB+CmNvnTzFvYqOOEmONDPx
         q2u/9OQqCKdg/QQPjitOvn5czH3chLldwTFF5/Tt8vLAOuHO4P2JXSxlCgOrk2LtcbyZ
         bFww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9p9eVD7iEikBC4jxuapL3VYhAWQBtz27pVnAlOGf5zE=;
        b=XvxUiIpL+nqJ2WS1nCwNMjWXNuWbGFhmtBoj0ffA37dErZlBCOSaMWmGyKnGm1XPoV
         wTYomvytgd6GH6P80flHxnd4NatUmQ3A5BHyDXx4X1pbWjdQ3lH6TBmEz04/enHHZofp
         Kxzi8wHxuL9GzhwACcKeOzT/itgIcHOXUc6f/3rPc6385Qdb5PNIFAEwcHcYLzKpDREy
         VOSL9XgGsu4NaChvDgyEz9K7s/X3z+zmNV7Lkw92z5hCGThX6iUNOaFv+kRRLh8fSQpK
         Vwa6i7r6iiGGmY4sSpR1jTHb9TDyGeDP/2MMftMzCTbowQN65L1UXxNeF4NYF63lC7yU
         B9jw==
X-Gm-Message-State: AOAM531qUZRdQ1FtAf+RCpD4SxHW3hzlTPYX1Kpbc/lEV1YhJyfU7KTb
        57U0spr0Y3fQ6ox1AjyNJ4DB1w==
X-Google-Smtp-Source: ABdhPJyg0c0xfEePFDAfiEKVwFjS/OFrsTaLMjnglwUOt9AxLJHqFm5OEEm8eUBOdTZqvAW4ZCPK3A==
X-Received: by 2002:a17:90a:9bc6:b0:1d8:2d8e:1b97 with SMTP id b6-20020a17090a9bc600b001d82d8e1b97mr81799pjw.45.1651251656592;
        Fri, 29 Apr 2022 10:00:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o3-20020a63f143000000b003c14af5062asm6196820pgk.66.2022.04.29.10.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:00:56 -0700 (PDT)
Date:   Fri, 29 Apr 2022 17:00:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Subject: Re: [PATCH v2 11/12] KVM: SVM: Do not inhibit APICv when x2APIC is
 present
Message-ID: <YmwZxAWJ8KqHodbf@google.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
 <20220412115822.14351-12-suravee.suthikulpanit@amd.com>
 <3fd0aabb6288a5703760da854fd6b09a485a2d69.camel@redhat.com>
 <01460b72-1189-fef1-9718-816f2f658d42@amd.com>
 <b9ee5f62e904a690d7e2d8837ade8ece7e24a359.camel@redhat.com>
 <41b1e63ad6e45be019bbedc93bd18cfcb9475b06.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41b1e63ad6e45be019bbedc93bd18cfcb9475b06.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> On Tue, 2022-04-26 at 10:06 +0300, Maxim Levitsky wrote:
> BTW, can I ask you to check something on the AMD side of things of AVIC?
> 
> I noticed that AMD's manual states that:
> 
> "Multiprocessor VM requirements. When running a VM which has multiple virtual CPUs, and the
> VMM runs a virtual CPU on a core which had last run a different virtual CPU from the same VM,
> regardless of the respective ASID values, care must be taken to flush the TLB on the VMRUN using a
> TLB_CONTROL value of 3h. Failure to do so may result in stale mappings misdirecting virtual APIC
> accesses to the previous virtual CPU's APIC backing page."
> 
> It it relevant to KVM? I don't fully understand why it was mentioned that ASID doesn't matter,
> what makes it special about 'virtual CPU from the same VM' if ASID doesn't matter? 

I believe it's calling out that, because vCPUs from the same VM likely share an ASID,
the magic TLB entry for the APIC-access page, which redirects to the virtual APIC page,
will be preserved.  And so if the hypervisor doesn't flush the ASID/TLB, accelerated
xAPIC accesses for the new vCPU will go to the previous vCPU's virtual APIC page.

Intel has the same requirement, though this specific scenario isn't as well documented.
E.g. even if using EPT and VPID, the EPT still needs to be invalidated because the
TLB can cache guest-physical mappings, which are not associated with a VPID.

Huh.  I was going to say that KVM does the necessary flushes in vmx_vcpu_load_vmcs()
and pre_svm_run(), but I don't think that's true.  KVM flushes if the _new_ VMCS/VMCB
is being migrated to a different pCPU, but neither VMX nor SVM flush when switching
between vCPUs that are both "loaded" on the current pCPU.

Switching between vmcs01 and vmcs02 is ok, because KVM always forces a different
EPTP, even if L1 is using shadow paging (the guest_mode bit in the role prevents
reusing a root).  nSVM is "ok" because it flushes on every transition anyways.
