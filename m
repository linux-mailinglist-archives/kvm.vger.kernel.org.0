Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840FA5A84B4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiHaRtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiHaRtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:49:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329B4D4BE9
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DeI1SmKit0K3Fr9de4qL5NqdwvAZGkC6KqoGn3Aeuzo=;
        b=IRsKDLZXT7uSxZilWmgxJFqUbkI7Ixg7Ok6yom4JSQMirre5wpw4DSMmxovjnRH+ZWMF5F
        5exqcmWr9BsCNsaxgbeQ3/0W170yw0gg+H/2Z+hRlUjv4MvwjBsYz70ODoO3PVSMxOZIFA
        q78xAi0/MhS0UGjvnvWZQB3duibkltQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-mDrMJF4KNvWKar9XXcUx9w-1; Wed, 31 Aug 2022 13:49:07 -0400
X-MC-Unique: mDrMJF4KNvWKar9XXcUx9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0135185A7BA;
        Wed, 31 Aug 2022 17:49:05 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AC9BC15BB3;
        Wed, 31 Aug 2022 17:49:04 +0000 (UTC)
Message-ID: <ffdd3daf51e1e192a260b2824842730ecfe124b3.camel@redhat.com>
Subject: Re: [PATCH 10/19] KVM: SVM: Document that vCPU ID == APIC ID in
 AVIC kick fastpatch
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 20:49:03 +0300
In-Reply-To: <Yw+JZODiHgvZVsAN@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-11-seanjc@google.com>
         <29542724f23fd15745bd137b99153bf8629907f0.camel@redhat.com>
         <Yw+JZODiHgvZVsAN@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:16 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > Document that AVIC is inhibited if any vCPU's APIC ID diverges from its
> > > vCPU ID, i.e. that there's no need to check for a destination match in
> > > the AVIC kick fast path.
> > > 
> > > Opportunistically tweak comments to remove "guest bug", as that suggests
> > > KVM is punting on error handling, which is not the case.  Targeting a
> > > non-existent vCPU or no vCPUs _may_ be a guest software bug, but whether
> > > or not it's a guest bug is irrelevant.  Such behavior is architecturally
> > > legal and thus needs to faithfully emulated by KVM (and it is).
> > 
> > I don't want to pick a fight,
> 
> Please don't hesitate to push back, I would much rather discuss points of contention
> than have an ongoing, silent battle through patches.
> 
> > but personally these things *are* guest bugs / improper usage of APIC, and I
> > don't think it is wrong to document them as such.
> 
> If the guest is intentionally exercising an edge case, e.g. KUT or selftests, then
> from the guest's perspective its code/behavior isn't buggy.
> 
> I completely agree that abusing/aliasing logical IDs is improper usage and arguably
> out of spec, but the scenarios here are very much in spec, e.g. a bitmap of '0'
> isn't expressly forbidden and both Intel and AMD specs very clearly state that
> APICs discard interrupt messages if they are not the destination.
> 
> But that's somewhat beside the point, as I have no objection to documenting scenarios
> that are out-of-spec or undefined.  What I object to is documenting such scenarios as
> "guest bugs".  If the CPU/APIC/whatever behavior is undefined, then document it
> as undefined.  Saying "guest bug" doesn't help future readers understand what is
> architecturally supposed to happen, whereas a comment like
> 
> 	/*
> 	 * Logical IDs are architecturally "required" to be unique, i.e. this is
> 	 * technically undefined behavior.  Disable the optimized logical map so
> 	 * that KVM is consistent with itself, as the non-optimized matching
> 	 * logic with accept interrupts on all CPUs with the logical ID.
> 	 */
> 
> anchors KVM's behavior to the specs and explains why KVM does XYZ in response to
> undefined behavior.
> 
> I feel very strongly about "guest bug" because KVM has a history of disregarding
> architectural correctness and using a "good enough" approach.  Simply stating
> "guest bug" makes it all the more difficult to differentiate between KVM handling
> architecturally undefined behavior, versus KVM deviating from the spec because
> someone decided that KVM's partial emulation/virtualziation was "good enough".
> 

All right, I agree with you.

Best regards,
	Maxim Levitsky

