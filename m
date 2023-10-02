Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F09A7B51DE
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbjJBL6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236604AbjJBL6W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9BC94
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 04:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696247852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xdEi4vgKgEG2jRiO+4XFkFqhlYVyHnR0EylKCN1L2xM=;
        b=W6km0XumYe2srix6tXm7OhkwOKFFd2P1Q8M/4VAAn6GJGbytAxMMEnvCmt8A8SK0cOL1Le
        3V6cnCrVoRvoo2h+92aGTknITa2L1paVj1UjhWBQQARxzJwOvYh3Wg+E77VWDglYyXV617
        qzycGXd4S1cacfrYYU2xiOJxc2WmsfE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-PTuM0XbWONejxasCbmtAbA-1; Mon, 02 Oct 2023 07:57:29 -0400
X-MC-Unique: PTuM0XbWONejxasCbmtAbA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B339197E40A;
        Mon,  2 Oct 2023 11:57:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 056A3140E950;
        Mon,  2 Oct 2023 11:57:24 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 0/4] Allow AVIC's IPI virtualization to be optional
Date:   Mon,  2 Oct 2023 14:57:19 +0300
Message-Id: <20231002115723.175344-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!=0D
=0D
This patch allows AVIC's ICR emulation to be optional and thus allows=0D
to workaround AVIC's errata #1235 by disabling this portion of the feature.=
=0D
=0D
This is v3 of my patch series 'AVIC bugfixes and workarounds' including=0D
review feedback.=0D
=0D
Best regards,=0D
    Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  KVM: Add per vCPU flag specifying that a vCPU is loaded=0D
  x86: KVM: AVIC: stop using 'is_running' bit in avic_vcpu_put()=0D
  x86: KVM: don't read physical ID table entry in avic_pi_update_irte()=0D
  x86: KVM: SVM: allow optionally to disable AVIC's IPI virtualization=0D
=0D
 arch/x86/kvm/svm/avic.c  | 72 ++++++++++++++++++++++++++--------------=0D
 include/linux/kvm_host.h |  1 +=0D
 virt/kvm/kvm_main.c      | 10 ++++++=0D
 3 files changed, 59 insertions(+), 24 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D

