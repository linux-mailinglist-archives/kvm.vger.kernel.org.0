Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4973F52ED28
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349752AbiETNcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiETNck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:32:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90B23163295
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653053558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W9lUTIUy4WtCyayKKPomN8o880KWoRZmSGFT9az1YwM=;
        b=iacYB/+OGiLyPB5AQiUSudOtl6BUI1o2aDpIL+lRWLPGWo/z/Q51sJzj1Mj2ofT1NdES5t
        ukDZ2rj3WoXrfERLxzWCSoMVA/QOrcIbiVqtBHTllWe12wO7/+utwgEv2YqKxmjJieA3F6
        RYjxZtLNToR+IyYaZht49AZs0VC6/cI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-253-roDXAEShN9KS248HMVjVJA-1; Fri, 20 May 2022 09:32:35 -0400
X-MC-Unique: roDXAEShN9KS248HMVjVJA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCCE81C04B54;
        Fri, 20 May 2022 13:32:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 546C341136E1;
        Fri, 20 May 2022 13:32:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 0/2]  KVM: x86/mmu: nEPT X-only unsync bug fix
Date:   Fri, 20 May 2022 09:31:16 -0400
Message-Id: <20220520133115.3319985-1-pbonzini@redhat.com>
In-Reply-To: <20220513195000.99371-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  Here is the new message for patch 1:

    All of sync_page()'s existing checks filter out only !PRESENT gPTE,
    because without execute-only, all upper levels are guaranteed to be at
    least READABLE.  However, if EPT with execute-only support is in use by
    L1, KVM can create an SPTE that is shadow-present but guest-inaccessible
    (RWX=0) if the upper level combined permissions are R (or RW) and
    the leaf EPTE is changed from R (or RW) to X.  Because the EPTE is
    considered present when viewed in isolation, and no reserved bits are set,
    FNAME(prefetch_invalid_gpte) will consider the GPTE valid, and cause a
    not-present SPTE to be created.

    The SPTE is "correct": the guest translation is inaccessible because
    the combined protections of all levels yield RWX=0, and KVM will just
    redirect any vmexits to the guest.  If EPT A/D bits are disabled, KVM
    can mistake the SPTE for an access-tracked SPTE, but again such confusion
    isn't fatal, as the "saved" protections are also RWX=0.  However,
    creating a useless SPTE in general means that KVM messed up something,
    even if this particular goof didn't manifest as a functional bug.
    So, drop SPTEs whose new protections will yield a RWX=0 SPTE, and
    add a WARN in make_spte() to detect creation of SPTEs that will
    result in RWX=0 protections.

Paolo


