Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03BE717D3B
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjEaKgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 06:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjEaKgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 06:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20CD113
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 03:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685529318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gYHVR8q7GPkHT/zLzUP2bY/8STQi3ZK3wYCNDXwLQn8=;
        b=Uk492eFC/v8aAubg+y9BWa5m9T1XYKa4M/qyoDtG8RLh3c6OvQj1Cp7VpHO/IM+VFB+7mM
        vr3f9aEdzBEWAY8DxqAaSyyZoRnnl3RHdzrGHFjYWST/5RJghBzfv5BvZS2Fl0ZfvnSOBj
        MusX4Mhq5H5GyXjx8gEQdUJU7KafoBo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-LCgoHUTnP96LH8ZdlTG4xg-1; Wed, 31 May 2023 06:35:17 -0400
X-MC-Unique: LCgoHUTnP96LH8ZdlTG4xg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4edc7ab63ccso3226340e87.3
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 03:35:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685529316; x=1688121316;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gYHVR8q7GPkHT/zLzUP2bY/8STQi3ZK3wYCNDXwLQn8=;
        b=cZ9XAKVlxL4m6SYRuM7vhxfNPa+5ogLUmm+OY/N8Jr4qQ62ZhKHX/RpfBri1jKcpqI
         pmBQKY+QEduFs/hebkXjf9A+WxQv75zhhAMsAxDrv8JnDx+3qdfinbBprvksBVGKZPOH
         vS+sCTKWyDkoFNv3lFocyWTuFPTVkvpGOilhLptb99s6z3HucjQJVQz8recHxXsA+mBe
         /BBWTu7yX1Dkrja+XGBotOCRTNwIDPYKo+w1QUXai92TEXT8lxLTiK89irxkwNfNaLGw
         HntUWl9mvPcZ7FDrmFpC1bxw4alVzI2S6gN2LzViaYfoxY9u5fd8bVQS1Yb9WpUZNu5I
         9j5A==
X-Gm-Message-State: AC+VfDzjoJS8iOfXJ67u+RFVda1Ea5ofeu63IkH+zVXak/HpJF258Ika
        kWoqGgoG3XW+tX3kGFwwecGLwyrIRwKiRCQEsNg8B/yZhAAnPXmQqrVws8h+uS6oiUDgpg5xNXF
        aL1neqfNqBomI1QgfNRHL
X-Received: by 2002:ac2:5935:0:b0:4f3:a99f:1ea1 with SMTP id v21-20020ac25935000000b004f3a99f1ea1mr2395541lfi.45.1685529315937;
        Wed, 31 May 2023 03:35:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4BinbmxD2hj5JGBEw3gbyqxIqScEPsApn13ZNzH1vCFbmx1++czjS5hGN5olVgYS6bzziuRA==
X-Received: by 2002:ac2:5935:0:b0:4f3:a99f:1ea1 with SMTP id v21-20020ac25935000000b004f3a99f1ea1mr2395526lfi.45.1685529315582;
        Wed, 31 May 2023 03:35:15 -0700 (PDT)
Received: from starship ([89.237.102.231])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c1d1200b003f61177faffsm3186266wms.0.2023.05.31.03.35.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 03:35:15 -0700 (PDT)
Message-ID: <5e18e1424868eec10f6dc396b88b65283b57278a.camel@redhat.com>
Subject: Re: [Bug] AMD nested: commit broke VMware
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     jwarren@tutanota.com, Kvm <kvm@vger.kernel.org>
Date:   Wed, 31 May 2023 13:35:13 +0300
In-Reply-To: <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com>
References: <NWb_YOE--3-9@tutanota.com>
         <357d135f9ed65f4e2970c82ae4e855547db70ad1.camel@redhat.com>
         <CALMp9eTyx1Y0yc7G0c0BsAig=Amv4DYtcNnWPmD-9JHP=ChZiw@mail.gmail.com>
         <CALMp9eSq1r87=jGWc1z85L-QGCTF-jpWgHEQxJ4sVCqCU_0KQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

У вт, 2023-05-30 у 13:34 -0700, Jim Mattson пише:
> On Tue, May 30, 2023 at 1:10 PM Jim Mattson <jmattson@google.com> wrote:
> > On Mon, May 29, 2023 at 6:44 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > > У пн, 2023-05-29 у 14:58 +0200, jwarren@tutanota.com пише:
> > > > Hello,
> > > > Since kernel 5.16 users can't start VMware VMs when it is nested under KVM on AMD CPUs.
> > > > 
> > > > User reports are here:
> > > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2008583
> > > > https://forums.unraid.net/topic/128868-vmware-7x-will-not-start-any-vms-under-unraid-6110/
> > > > 
> > > > I've pinpointed it to commit 174a921b6975ef959dd82ee9e8844067a62e3ec1 (appeared in 5.16rc1)
> > > > "nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"
> > > > 
> > > > I've confirmed that VMware errors out when it checks for TLB_CONTROL_FLUSH_ASID support and gets a 'false' answer.
> > > > 
> > > > First revisions of the patch in question had some support for TLB_CONTROL_FLUSH_ASID, but it was removed:
> > > > https://lore.kernel.org/kvm/f7c2d5f5-3560-8666-90be-3605220cb93c@redhat.com/
> > > > 
> > > > I don't know what would be the best case here, maybe put a quirk there, so it doesn't break "userspace".
> > > > Committer's email is dead, so I'm writing here.
> > > > 
> > > 
> > > I have to say that I know about this for long time, because some time ago I used  to play with VMware player in a
> > > VM on AMD on my spare time, on weekends
> > > (just doing various crazy things with double nesting, running win98 nested, vfio stuff, etc, etc).
> > > 
> > > I didn't report it because its a bug in VMWARE - they set a bit in the tlb_control without checking CPUID's FLUSHBYASID
> > > which states that KVM doesn't support setting this bit.
> > 
> > I am pretty sure that bit 1 is supposed to be ignored on hardware
> > without FlushByASID, but I'll have to see if I can dig up an old APM
> > to verify that.
> 
> I couldn't find an APM that old, but even today's APM does not specify
> that any checks are performed on the TLB_CONTROL field by VMRUN.
> 
> While Intel likes to fail VM-entry for illegal VMCS state, AMD prefers
> to massage the VMCB to render any illegal VMCB state legal. For
> example, rather than fail VM-entry for a non-canonical address, AMD is
> inclined to drop the high bits and sign-extend the low bits, so that
> the address is canonical.
> 
> I'm willing to bet that modern CPUs continue to ignore the TLB_CONTROL
> bits that were noted "reserved" in version 3.22 of the manual, and
> that Krish simply manufactured the checks in commit 174a921b6975
> ("nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB"),
> without cause.
> 
> > > Supporting FLUSHBYASID would fix this, and make nesting faster too,
> > > but it is far from a trivial job.
> > > 
> > > I hope that I will find time to do this soon.
> > > 
> > > Best regards,
> > >         Maxim Levitsky
> > > 
> > > 

Yup...

After applying this horrible hack to KVM, the VM still boots just fine
on bare metal.

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e7c7379d6ac7b0..2e45c1b747104a 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -170,10 +170,10 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 };
 
 
-#define TLB_CONTROL_DO_NOTHING 0
-#define TLB_CONTROL_FLUSH_ALL_ASID 1
-#define TLB_CONTROL_FLUSH_ASID 3
-#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
+#define TLB_CONTROL_DO_NOTHING 0xF0
+#define TLB_CONTROL_FLUSH_ALL_ASID 0xF1
+#define TLB_CONTROL_FLUSH_ASID 0xF3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL 0xF7
 
 #define V_TPR_MASK 0x0f
 

Shall we revert the offending patch then?

Best regards,
	Maxim Levitsky

