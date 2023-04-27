Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16EE16F0CE2
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 22:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344077AbjD0UL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 16:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbjD0UL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 16:11:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C7A3C01
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682626277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AhZUeHYpeOBAxV0IzIBwDv//tE17MPSk4ZjZmgXSJWI=;
        b=H0033ZNHD+GDaqWZVeb59pAKw4dl4F2sMvrSMvaechkQl4N2iMiQs4Lx2p8cBf9a8yFsC1
        2mnuqbhxQB3yWYzhPdm10ADoj4BfTRDhm7Xv+4hU+J0kjXjfJMnDIWNRHkL9WCUTWJiriR
        oCxDgNqoFYKDhPNcA2L0u7aaqMXvDZ4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-7H6xHAtZOUyvRf03Y5VCmg-1; Thu, 27 Apr 2023 16:11:15 -0400
X-MC-Unique: 7H6xHAtZOUyvRf03Y5VCmg-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3ef32210cabso19397091cf.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:11:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682626274; x=1685218274;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhZUeHYpeOBAxV0IzIBwDv//tE17MPSk4ZjZmgXSJWI=;
        b=NHvRnLeP2DDgkHX4BZj/wY7tDJQPAltLjwzZ2pswB9W8yswnteByXm4vYV27q01Z5S
         rxq4nTo3Wp2POuP6WP/l4Mhu92i3WgfBALjYks5mDVQoOFodJnwMwy9IcMWD53BTgjOF
         OiSiKW7JC6rvClk8bwo8l9GXvk1ulw1WQP4C4TtHnHlvV8afMnKl9eBEPvtMlciy0nae
         3gEzSITKFPrbM/L6mAGJ4QuSSZ63fPZAgkf2XiijRd/rttlqnmjSi2MMGepEImOzKT92
         F9CLiKgjJQ7fCOMAICeOKD8X+3oqi+VT0Xh4+YQW/EPH7l4xJxo7Gnzkp/6O2hUX4rQ+
         j93A==
X-Gm-Message-State: AC+VfDwo4GVYRxpYxt81UbZblbG35rQLiQnQokEpSZWccmQXKys75/AB
        44HE9XjtbJBbo2ZjxP8giH/CUFBbDbYZGoFUSVl19DOIGzg1NUxBwfaeh8+WjM3BJhOuFxsv5IZ
        eFFxsUSI57s767WtQckN4
X-Received: by 2002:a05:622a:11d3:b0:3ea:ef5:5b8c with SMTP id n19-20020a05622a11d300b003ea0ef55b8cmr5145327qtk.3.1682626274705;
        Thu, 27 Apr 2023 13:11:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4VhE7QH8N5ots5VW8DKCbhdRPJyfLcsNh6MOOG1ylNSxk/alsE/WyTGIrq2TqNMWsuuXaC5A==
X-Received: by 2002:a05:622a:11d3:b0:3ea:ef5:5b8c with SMTP id n19-20020a05622a11d300b003ea0ef55b8cmr5145287qtk.3.1682626274390;
        Thu, 27 Apr 2023 13:11:14 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b0074fb065bde4sm3444283qkn.18.2023.04.27.13.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 13:11:13 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>, peterx@redhat.com,
        Anish Moorthy <amoorthy@google.com>
Subject: [PATCH 0/2] selftests/kvm: Fixes for demand paging test
Date:   Thu, 27 Apr 2023 16:11:10 -0400
Message-Id: <20230427201112.2164776-1-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two trivial fixes per subject, please see each patch, thanks.

Peter Xu (2):
  selftests/kvm: Setup vcpu_alias only for minor mode test
  selftests/kvm: Allow dump per-vcpu info for uffd threads

 .../testing/selftests/kvm/demand_paging_test.c  | 17 +++++++++--------
 .../selftests/kvm/lib/userfaultfd_util.c        |  4 ++--
 2 files changed, 11 insertions(+), 10 deletions(-)

-- 
2.39.1

