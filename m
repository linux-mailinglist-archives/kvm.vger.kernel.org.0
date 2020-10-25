Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B30F298334
	for <lists+kvm@lfdr.de>; Sun, 25 Oct 2020 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418308AbgJYSxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Oct 2020 14:53:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1417005AbgJYSxl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 25 Oct 2020 14:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603652019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=l9opdhjO8wDOyQJdye7Bnt0YjHd2izk2OycmVO/q0mQ=;
        b=aiX+9t2+xZ1n8/qalb0NvsGI7a8Quv7R7WJsUDEpp0K3xEK2MkVPSqkt17HfrnGTwyqcSm
        4uOrmV+iMVfqk4/bLOs9AgPUaDkWB5+PmyeYqPNUL0zCSh13jMJKXTsXSdAFG9SRSnUFwY
        HxjNOSuFy7Jr6qIvGNPInQ5dYjUGoGM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-kn39ADr1MUurC6PvNMNQtw-1; Sun, 25 Oct 2020 14:53:37 -0400
X-MC-Unique: kn39ADr1MUurC6PvNMNQtw-1
Received: by mail-qt1-f198.google.com with SMTP id c4so4909362qtx.20
        for <kvm@vger.kernel.org>; Sun, 25 Oct 2020 11:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l9opdhjO8wDOyQJdye7Bnt0YjHd2izk2OycmVO/q0mQ=;
        b=OyEkHWhRwKchb56a205tgNrU0I8faWpkGCoiRHeQLj+OduJ54slyNOkDp7X7/R6TS5
         OgHKsFhfoWK8FEFET82qnYF2VtsbqlOabCAW6SR/HCE4WADl2WXxymHV0hfMHPQbFctU
         uP2x1HJlD0JvLSBSxBUZKCb7lo914MVLabnskAz4pduzdsveqKYyr/xWtVlh5xrkaKTO
         kcb3Hrw1LtEVDvt0due22a3unSo4VdmZgjq4xRiHOr1CQaqgKwZ9zSkyWXL5B2LwNJJ8
         KmyKsC27uN0qtrkptakk6LI0DqyXcFm2nloUKo8BtIkjs3TbCuA0R0pA/8s5Qlk17NvV
         We8w==
X-Gm-Message-State: AOAM533ztTtrwwxKY+fCP9aOToC6sNYysF/TGrgp/rNjBhLeFhW+pp5+
        QB2q1umcAVO3y2sUGEW54ZGGrkwEcglkrd2FSyXQiR20dOHnVTTKf2kMfbf9lfWSOhDWRK2yQAg
        eZdrFFStelQrJ
X-Received: by 2002:ac8:3510:: with SMTP id y16mr13427400qtb.300.1603652017282;
        Sun, 25 Oct 2020 11:53:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5KhSGchYzMGbuUSH7VwFwskXs0eZ8seChI+2sD6xWskBYWXULVezbnh/8TWgCLDUqJS/SKA==
X-Received: by 2002:ac8:3510:: with SMTP id y16mr13427384qtb.300.1603652017070;
        Sun, 25 Oct 2020 11:53:37 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id y3sm5305224qto.2.2020.10.25.11.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2020 11:53:36 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] Fix null pointer dereference in kvm_msr_ignored_check
Date:   Sun, 25 Oct 2020 14:53:32 -0400
Message-Id: <20201025185334.389061-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bug report: https://lore.kernel.org/kvm/bug-209845-28872@https.bugzilla.ker=
nel.org%2F/=0D
=0D
Unit test attached, which can reproduce the same issue.=0D
=0D
Thanks,=0D
=0D
Peter Xu (2):=0D
  KVM: selftests: Add get featured msrs test case=0D
  KVM: X86: Fix null pointer reference for KVM_GET_MSRS=0D
=0D
 arch/x86/kvm/x86.c                            |  4 +-=0D
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +=0D
 tools/testing/selftests/kvm/lib/kvm_util.c    | 14 +++++=0D
 .../testing/selftests/kvm/x86_64/state_test.c | 58 +++++++++++++++++++=0D
 4 files changed, 77 insertions(+), 2 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

