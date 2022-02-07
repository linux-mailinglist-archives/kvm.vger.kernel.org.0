Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930904AC868
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiBGSTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 13:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344969AbiBGSOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 13:14:00 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B040C0401D9
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 10:13:59 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id a8so14375549pfa.6
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 10:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gELMWqQm1ylvlr8c0+U4NH+p+39jLDivrZdQ+7c9zxg=;
        b=SS8lk/Gx4Nr1E3apckw8IQnjZwQYMvdDubxAco48TzU2DsQLgRrgiHnVigSDL1sWb0
         v667QYOitDZOQD/ahbUB35rLmQayUrnfOhQ3LZa4XTvIoYANKNumGcDx6ewT9lxdx+fJ
         2W5GV5AGq+VBul7muAf4pKsjYgxqD0zqOV4I5/EjO4WllKx+zaRnbz3ytpQdAp0waTyC
         w1tcIPqhCXVIPpU828uVbQ4SGnrXFuuarI9npvs/l3yCSJgN1/Jqv8rNcyf4vDqQ4Www
         bQwNJkuuZIX1DSGP9+qu3lKRABWSC9Cf1tE0df98U1nSASFizefBzbDCwAm8Sy4cd6CM
         igKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gELMWqQm1ylvlr8c0+U4NH+p+39jLDivrZdQ+7c9zxg=;
        b=fQ7bClzBjeQFCeUS/XywfuTGQjafgTtS74eiwfnxPbGUHIDgHKv4LTeEMZaQOWgHpD
         tTjI2K8sKBGFqHtx1TMLjObGJ0TZkXlLD9YxnEmthqvHpPz/D93U002AixyUGKin1nTp
         op4E8LU0ZAi4dd+CpLj+vK1KhFUnoQpsXpkDgypndhyOoU8H/sKtmhFamW4svOgEtIlS
         /gQ5Px6ky1KTQxbfYUooNwL32aIIvI/ap4f9TdwYvX2jrT6gpXKQn4HeHlhQN+4dIH8j
         Fhg8NFrmMRaueSFgqCGnIofqKs/vY0kKpNy63ZrA5k4eMTwyb/jla4IO5Eaype57kzfu
         OF0Q==
X-Gm-Message-State: AOAM531dkGdExSjCctUX9y+mAMa2CW+5bxV57cUqz/x+vexp7z4OQ+t0
        +8mp7FQ0JjkerIFzztSyhvOn7Q==
X-Google-Smtp-Source: ABdhPJx7XKboEu0OKmYC/1+vWKa9D+wqizv3XtDyygvGwPoEwp4dHATOfsMgYPnxY1+OUzztwZ5YYA==
X-Received: by 2002:a63:6c89:: with SMTP id h131mr524778pgc.80.1644257638775;
        Mon, 07 Feb 2022 10:13:58 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f64sm12404538pfa.165.2022.02.07.10.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:13:58 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:13:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 1/7] KVM: nVMX: Keep KVM updates to BNDCFGS ctrl bits
 across MSR write
Message-ID: <YgFhYi4pqh85/rlF@google.com>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-2-oupton@google.com>
 <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6e9ae4-2e5b-7078-5322-05b7a61079b4@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 07, 2022, Paolo Bonzini wrote:
> On 2/4/22 21:46, Oliver Upton wrote:
> > Since commit 5f76f6f5ff96 ("KVM: nVMX: Do not expose MPX VMX controls
> > when guest MPX disabled"), KVM has taken ownership of the "load
> > IA32_BNDCFGS" and "clear IA32_BNDCFGS" VMX entry/exit controls. The ABI
> > is that these bits must be set in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS
> > MSRs if the guest's CPUID supports MPX, and clear otherwise.
> > 
> > However, KVM will only do so if userspace sets the CPUID before writing
> > to the corresponding MSRs. Of course, there are no ordering requirements
> > between these ioctls. Uphold the ABI regardless of ordering by
> > reapplying KVMs tweaks to the VMX control MSRs after userspace has
> > written to them.
> 
> I don't understand this patch.  If you first write the CPUID and then the
> MSR, the consistency is upheld by these checks:
> 
>         if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
>                 return -EINVAL;
> 
>         if (!is_bitwise_subset(supported, data, GENMASK_ULL(63, 32)))
>                 return -EINVAL;
> 
> If you're fixing a case where userspace first writes the MSR and then sets
> CPUID, then I would expect that KVM_SET_CPUID2 redoes those checks and, if
> they fail, it adjusts the MSRs.
> 
> The selftests confirm that I'm a bit confused, but in general
> vmx_restore_control_msr is not the place where I was expecting the change.

Do we even need this change?  The ABI is whatever it is, not what may or may not
have been intended by a flawed, 3+ year old commit.   E.g. if there's a userspace
that relies on being able to override KVM's tweaks by writing the MSRs after
setting CPUID, then this commit will break the ABI for that userspace.  The quirk
should be sufficient warning that KVM's behavior is funky.
