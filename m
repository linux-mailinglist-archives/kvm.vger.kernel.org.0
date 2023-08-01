Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B46A76BBCD
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 19:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbjHAR6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 13:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbjHAR6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 13:58:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662AA103
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=8I/mwzZvDUq3i74BLGvziom1tSRSihtpC0IkNTFAoFQ=; b=JzKH+x/CvRZeYDEEIseBUM+3TO
        qwuaxnuefoWln4HNkgPfJ8Q6xyJFEjSsvSJ2iQfqHn6Lg5bZK4V3wS0SVragOllrXbsGddq6JbQ8T
        8OgS+be7cQY9r/ZBkzmoZl7grZrqWtM+4N+TpeHeoOBH8LbENuy6mlAPOvHr2z7zxT+rNnqBxCbWj
        Qmtnvm/n6xh9OUkOcItSjpPLF33EgL0fXMTS90xi1BmjvvKKvwAFKV3ZAY2DxurHnjs+M1rJX4W7p
        k1/hheIbLQMq7LPWjGCNSZkPT7/m9dYMELt5NInx88+MV2uYLFp/b00BQ/XZznGuxoRrrSkI5brW0
        2scAxPIA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qQtd2-00EpEL-0o;
        Tue, 01 Aug 2023 17:57:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qQtcz-000bxd-1F;
        Tue, 01 Aug 2023 18:57:49 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Anthony PERARD <anthony.perard@citrix.com>
Subject: [PATCH for-8.1] Misc Xen-on-KVM fixes
Date:   Tue,  1 Aug 2023 18:57:44 +0100
Message-Id: <20230801175747.145906-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A few minor fixes for the Xen emulation support. One was just merged, but
there are three outstanding.

David Woodhouse (3):
      hw/xen: fix off-by-one in xen_evtchn_set_gsi()
      i386/xen: consistent locking around Xen singleshot timers
      hw/xen: prevent guest from binding loopback event channel to itself

 hw/i386/kvm/xen_evtchn.c  | 15 +++++++++++----
 target/i386/kvm/xen-emu.c | 36 ++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 14 deletions(-)


