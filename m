Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3527A707BC9
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 10:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjERIUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 04:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjERIUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 04:20:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DB2A8
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 01:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684397996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O7SGy7rMxbEwtpa+tWNrhlxRFbH9WA0KS858zsQ4oX0=;
        b=IdziU2/fa/0rp0GEpK5g6oxNOhME90PiopO61EiBL4j/zbzzdzoY92AzU5Rav2fXug3ou0
        zKeMcEuH91dnPHKjjtJ/tNTM1uk31TI4gtmqmG/RmZvRad+s7YfdVoWyFsC9RuQtlYArjk
        IF6aH++4Yd1S4ojleIV3p98elLveRsE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-cHpews2zN1uxR2qorPKxMA-1; Thu, 18 May 2023 04:19:54 -0400
X-MC-Unique: cHpews2zN1uxR2qorPKxMA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30643d4a430so662034f8f.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 01:19:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684397993; x=1686989993;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O7SGy7rMxbEwtpa+tWNrhlxRFbH9WA0KS858zsQ4oX0=;
        b=lzXcGvrMpjrin4YpSVWhf+NM2yBqFY0yPFUOyGO7d5V8DssoQDEF5XnRb5YB+1sSIq
         RcFIf198weFH8W/kFgtycdkolg6PUcJ4hrWpCBFtjxO0aDKaR8PkgJPeXzsn7s5/hQAV
         wDhZoe7dCUIO24JMgP7HSi5F+0c7TkrLkJPzidKRZPJHiL9cFfGqlYbCNCpRGM3CWT0I
         CQGPPlQPRFxGNN+N6RlKX/6wzyPGarNJwnFL3q7QQSOQh/gTvYByb8XKxUE4e3ryQn/t
         zhumMm2UJPtmgVDQv31hROqPVhDZW9/5Max8V+y9ONsJyTgLE9uneoN5FUICpwM0+cj2
         Ryzw==
X-Gm-Message-State: AC+VfDxu/BxJLydabDmjxTNWT7b74/jDCUxDVTtJyVGBEEGTZbiBeTg2
        684FPFLCDTVHMUfB8iB1FRXPSN9SN9rZ550AtF3Hhu9GuOcv2u+lePJ/U9TtO1VEfQSD/mpX8Rv
        1DrqAnSczB69D
X-Received: by 2002:adf:eb0d:0:b0:2f5:3fa1:6226 with SMTP id s13-20020adfeb0d000000b002f53fa16226mr957441wrn.14.1684397993479;
        Thu, 18 May 2023 01:19:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5eX9wnE31nL9kxUJNZ5MuBWi+BP4QV43hFOiomJItwcWAtEl4Cp9xCs2G4KmM+Yw2PMmQBiw==
X-Received: by 2002:adf:eb0d:0:b0:2f5:3fa1:6226 with SMTP id s13-20020adfeb0d000000b002f53fa16226mr957422wrn.14.1684397993124;
        Thu, 18 May 2023 01:19:53 -0700 (PDT)
Received: from starship ([89.237.102.231])
        by smtp.gmail.com with ESMTPSA id l5-20020adfe585000000b002f7780eee10sm1327483wrm.59.2023.05.18.01.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 01:19:52 -0700 (PDT)
Message-ID: <2f6210acca81090146bc1decf61996aae2a0bfcf.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "dengqiao.joey" <dengqiao.joey@bytedance.com>,
        joao.m.martins@oracle.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com
Date:   Thu, 18 May 2023 11:19:49 +0300
In-Reply-To: <20230518035806.938517-1-dengqiao.joey@bytedance.com>
References: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
         <20230518035806.938517-1-dengqiao.joey@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У чт, 2023-05-18 у 11:58 +0800, dengqiao.joey пише:
> On Wed, May 17, 2023 at 11:32 PM Joao Martins <joao.m.martins@oracle.com> wrote:
> > On 17/05/2023 13:04, dengqiao.joey wrote:
> > > This seems to be a different issue. Joao's patch tries to fix the issue
> > > that IRTE is not changed. The problem I encountered is that IRTE does
> > > get changed, thus the destination field is also cleared by
> > > amd_iommu_activate_guest_mode().
> > 
> > Whether the amd_iommu_activate_guest_mode() clears the destination field or not
> > doesn't change the situation I think. So I don't think that is the problem
> > you're having. amd_iommu_activate_guest_mode() will always make IRTEs with
> > isRun=0. Which means your VF interrupts get injected via GALog events and the
> > DestID is meaningless there :/ Even if you leave the old affinity there with
> > isRun=1 bit it's still wrong as by the time you run the vcpu, the wrong affinity
> > will be used by the VF. More fundamentally I am not sure that on IRTE routing
> > updates in the VM that you can look on vcpu->cpu the way you are using it could
> > be potentially invalid when vcpus are blocked/preempted. You're changing IRTEs
> > in the whole VM in pi_update_irte()
> > 
> > My changes essentially handle the fact where IRTEs will be always updated with
> > the right GATag set in the IRTE ... and then when the vCPU migrates, wakes or
> > block+unblocks it will change IRTE[DestID] with the new pcpu (which the vcpu is
> > running on) via amd_iommu_update_ga(). So there's a good chance my changes fixes
> > your affinity issue.
> > 
> >         Joao
> 
> Sorry I forgot to mention before that in my application scenario, the vcpu runs on
> a dedicated isolated cpu and uses "mwait" instead of "halt". So it will not be migrated,
> blocked/wake and rarely get preempted by other threads. I think your patch can not fix
> my issue because the vcpu rarely gets the opportunity to execute amd_iommu_update_ga()
> from vcpu_load().
> 
> So each time the interrupt affinity is updated I can observe the loss of VF interrupt.
> After applying my patch, the problem is solved.
> 

Just to see if I understand the issue correctly:

vcpu 'affinity' of hardware interrupt to a guest vCPU 
(which is in AMD case pretty much address of apic backing page + vector)

changes in these cases:

1. when new VFIO device is attached to the VM and the guest enables MSI,
which triggers attachment of irqfd which is matched with eventfd from the
hardware device and irq bypass is created.

2. when the guest changes the MSI/MSI-X settings - this is similar to 1,
and can happen any time

3. When the vCPU is migrated.

As I understand the case 1 and 2, the avic_pi_update_irte is called and indeed,
if the vCPU is already running and in MWAIT/HLT state especially, then
it will no longer receive doorbell kicks, and the GA log handler won't do anything
to this vCPU either since it is running (it just does kvm_vcpu_wake_up)


In case 3, the vCPU is loaded again eventually and that calls the 
avic_update_iommu_vcpu_affinity which calls into iommu 'amd_iommu_update_ga'
to update target vCPU in the iommu remap entry.


Now it is possible that usually the MSI/MSI-x config space updates don't happen often
(e.g if guest doesn't migrate interrupts often, or device has per cpu interrupts (e.g nvme)),
and also vcpu loads/puts mask this, especially since MSI config space update itself is done
via userspace vmexit (e.g qemu machine model) which also triggers vcpu load/puts.

I think that we do need to a flag indicating if the vCPU is currently running and if yes,
then use svm->vcpu.cpu (or put -1 to it when it not running or something)
(currently the vcpu->cpu remains set when vCPU is put)

In other words if a vCPU is running, then avic_pi_update_irte should put correct pCPU number,
and if it raced with vCPU put/load, then later should win and put the correct value.
This can be done either with a lock or barriers.

In the current form, this patch is wrong since if the target is sleeping, then it will tell iommu
to send doorbells to last pCPU the target was running on.

FYI, I had the same issue with my nested avic implementation - when we have a nested vCPU run,
I need to translate the shadow physid table with the pCPU numbers, and in the same time,
vCPU migration also triggers update to the same table. I used a lock in the first implementation
but it can be improved.

As for varibale I used a private svm variable, 'nested_avic_active' which were true only when
the vCPU is loaded and its nested avic activated.

Best regards,
	Maxim Levitsky

