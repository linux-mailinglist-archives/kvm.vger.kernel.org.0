Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C20D519FC0
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 14:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbiEDMoj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 08:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349866AbiEDMoa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 08:44:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A882D344F8
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651668053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p42ujX9orUiN3OgFIB7H1+2tqHSQ2wyI3UPSSooZMyQ=;
        b=VtQMbm/wasnhsJuBP4vfgpMEBGeihp0rv/Vm/71GMMCsjiqEBrpNG0+flP5JegT0NeAzg6
        7t00W4eFz6c2tRYzzyekx4VVT9a+oDQMoAV+hy0Om7nEeX/rWOhSafUfCvUTNdHaCRlYR7
        IO+zRf/9o1f3y7j5epo1PJIe1PtZvKg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-CcVyKRYINI-YO_JLDinMVQ-1; Wed, 04 May 2022 08:40:50 -0400
X-MC-Unique: CcVyKRYINI-YO_JLDinMVQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 241FA29AB40B;
        Wed,  4 May 2022 12:40:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECAD4155F649;
        Wed,  4 May 2022 12:40:47 +0000 (UTC)
Message-ID: <03ff8d87c7aa513cf4b394b7ef5a769c17f865fa.camel@redhat.com>
Subject: Re: [PATCH v3 00/12] KVM: SVM: Fix soft int/ex re-injection
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 04 May 2022 15:40:46 +0300
In-Reply-To: <YnF46K33TOKqpAUs@google.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
         <YnF46K33TOKqpAUs@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-05-03 at 18:48 +0000, Sean Christopherson wrote:
> On Mon, May 02, 2022, Maciej S. Szmigiero wrote:
> > From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> > 
> > This series is an updated version of Sean's SVM soft interrupt/exception
> > re-injection fixes patch set, which in turn extended and generalized my
> > nSVM L1 -> L2 event injection fixes series.
> > 
> > Detailed list of changes in this version:
> > * "Downgraded" the commit affecting !nrips CPUs to just drop nested SVM
> > support for such parts instead of SVM support in general,
> > 
> > * Removed the BUG_ON() from svm_inject_irq() completely, instead of
> > replacing it with WARN() - Maxim has pointed out it can still be triggered
> > by userspace via KVM_SET_VCPU_EVENTS,
> > 
> > * Updated the new KVM self-test to switch to an alternate IDT before attempting
> > a second L1 -> L2 injection to cause intervening NPF again,
> > 
> > * Added a fix for L1/L2 NMI state confusion during L1 -> L2 NMI re-injection,
> > 
> > * Updated the new KVM self-test to also check for the NMI injection
> > scenario being fixed (that was found causing issues with a real guest),
> > 
> > * Changed "kvm_inj_virq" trace event "reinjected" field type to bool,
> > 
> > * Integrated the fix from patch 5 for nested_vmcb02_prepare_control() call
> > argument in svm_set_nested_state() to patch 1,
> > 
> > * Collected Maxim's "Reviewed-by:" for tracepoint patches.
> > 
> > Previous versions:
> > Sean's v2:
> > https://lore.kernel.org/kvm/20220423021411.784383-1-seanjc@google.com
> > 
> > Sean's v1:
> > https://lore.kernel.org/kvm/20220402010903.727604-1-seanjc@google.com
> > 
> > My original series:
> > https://lore.kernel.org/kvm/cover.1646944472.git.maciej.szmigiero@oracle.com
> > 
> > Maciej S. Szmigiero (4):
> >   KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
> >   KVM: SVM: Don't BUG if userspace injects an interrupt with GIF=0
> 
> LOL, this should win some kind of award for most ridiculous multi-author patch :-)
> 
> Series looks good, thanks!
> 
Well I think I, Paolo, and you hold the record for this, when we fixed the AVIC inhibition
races, remember?

Patch series also looks overall good to me, but I haven't checked everything to be honest.

Best regards,
	Maxim Levitsky

