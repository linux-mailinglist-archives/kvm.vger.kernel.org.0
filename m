Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD72C2B1D
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 01:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731781AbfI3Xwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 19:52:50 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:38266 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfI3Xwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 19:52:50 -0400
Received: by mail-pl1-f180.google.com with SMTP id w8so4077631plq.5
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 16:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=ranpv+u4AWu/umFwG9f+ZUmaHTII09W03ZRNBHBFGiY=;
        b=txeDirgX7GLHZFrkxejSJAyewUXSeL9PmJ7BqYMkWOv5pCiDtCndMKEfkX3t0qZhX0
         7EdB7y8OQIqYPNiLjmDg7cnPpz18yteSiFHhLaqixdhV8nSOgVuFk9GhWvUJtS8N98yi
         If5uK8IDhrffRPkstf++EOENZudeSRQPiM/ZLKBVf6n7BnOFKQ7KB5Sa2S+s2dhqk8Fd
         NX3ZtEHoFKJnGbOxh8BzFQv1SQl0iwud/6j3BYf7AMaJyj8vgfCBQurJL7QBQeHxqmGN
         mZWpuv65lk60csE0UWiLaqNMJzI0EPk7qedgKTAb9U1LvJkn5QpUCNaEwp8WT51lBhOA
         fWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=ranpv+u4AWu/umFwG9f+ZUmaHTII09W03ZRNBHBFGiY=;
        b=GomGihxDswE4kDkUdXfSSXeAA1fO1w3wW7/qXyWzOHbD/8mpuR6X72iSazu3xqHbJD
         csNMpOSFSWYVLN8+pCFI34w4iF3auVvD2E4FmC2GP/WAWxSqDpY7Kyq033OffVcm7WIz
         2KPTT/+co2kcbDopsrb/EdAFXs3EJnLYwpOZkI6yRzPaG5M25KIvL1aJjXx0m+WiZjrS
         dg3ZEBinR5sb+ZMuHpbB7EXLPHipSrzBd/aLSomvhPh5svRetJXjYJIVHBBmE4woY8uy
         RzCWRaby4oBylxDPR+U8182JY5J1BIb/I+CVxdv/dt4ccSA07150Aduuo7Rq+yizOp/6
         wIIg==
X-Gm-Message-State: APjAAAV7Jgo8phdMLtFAbdp4Fbf0KtXKVTAfNdFilcMSNHohtrt0jQRZ
        2JmZPLVj5hLQd82VSjzqIbc=
X-Google-Smtp-Source: APXvYqz+rePZ62lPNkWOjmle58b7x2hUlDGiRODN8ugEtNY/6uGJ1ARYPxvDjEJubCZIXSq0Vi5ntA==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr21793177pla.55.1569887567982;
        Mon, 30 Sep 2019 16:52:47 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id 20sm12996876pfp.153.2019.09.30.16.52.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 16:52:47 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: vmcs_shadow_test_field() bug
Message-Id: <3235DBB0-0DC0-418C-BC45-A4B78612E273@gmail.com>
Date:   Mon, 30 Sep 2019 16:52:45 -0700
Cc:     kvm list <kvm@vger.kernel.org>
To:     Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Just a gentle reminder from an old off-list email (here is a slightly
revised version of it):

Running kvm-unit-tests on bare-metal cause the VMCS shadow tests to fail =
with
errors such as:

 FAIL: valid link pointer: field 6c22: VMREAD and VMWRITE permission: =
VMX_INST_ERROR (0) is as expected (12)

Looking at the test code, I noticed a bug in vmcs_shadow_test_field(), =
which
indicates there is both a bug in KVM and kvm-unit-tests. Apparently, =
when
shadow-VMCS emulation is on, and when there is a VMREAD/VMWRITE error =
while
L2 performs VMREAD/VMWRITE, the test expects the VMX_INST_ERROR field of
VMCS12 to hold an error indication. But in fact, it is VMCS23 that is
supposed to hold an error indication.

This seems like a data leak between L1 and L2, although admittedly a =
very
very minor one.

Regards,
Nadav=
