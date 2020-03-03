Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9E17769D
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgCCNEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:04:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35649 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgCCNEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 08:04:06 -0500
Received: by mail-wm1-f67.google.com with SMTP id m3so2774008wmi.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBC2YbhZkJ0v6nz38kCdb3gf7pmanp7d2q2V1CxXpg8=;
        b=UwUGsP2peGrcDb+FuDOl36Uomb459AEZ0alK/qYf7ru06yn03UUn/cWusqOO4GCcdE
         KFyRoWEy+kiGPgcFZk/6AVvEaVjvfyQf1pJRc6Bo4ypA3mLnoNRS6TZKizWJ2txKRFWy
         iQjxA+2zl4NaZI6cdAELzHRg3sY0WEO9hW8BjiwA+kdMxJI2tkaiJMTQu/SzrSm2k0vv
         WM+uNp85yE6gtWw2CWrUZZpJVsMW9P4iNhB0v01RU8vF5sJiJNYTIR0vKI9gsOU5UCwF
         SfS3QEaC24GBmTBtNTIcNXYBbP/E6pA2nxGY75CdyvYUjIN1i72/Vc9Bts/FacI0gpEI
         kwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vBC2YbhZkJ0v6nz38kCdb3gf7pmanp7d2q2V1CxXpg8=;
        b=MN6WtCoY8EpqcobDSKWlKgWG7HvyBVmi37+jmfmqfDhw0uN5r7YPmOLbR1MBnwlHHw
         c8tguPHNUrVPVI0OdNz+AVveRMPxq6o0gUZQxWFRI7bt/BFcpW32inEtI5bk5q9EBmVn
         cE+JVlAhyHVod8QvjadHi1Zn6z+WD+Oi1+VQ8Y2m2amANo+YoRGEr/2Lr2Fs6WAghYwR
         MWmLnycO8OuZiv9+TvRZzwUvQpX/LXCfI4N+m9PfO8Bc+FClRalwdu8dNzvqeAda5TAl
         kQsgOVlc1fW3kAluu+CMmh6rZRnv1qjuizWPMfkmtjgbwkgDzfdOKaCHJBAGXIqIgVRk
         Ov8A==
X-Gm-Message-State: ANhLgQ1jWZNQ59UUrY01hVPRv6da/wL6HF/6YhaCiIj8Bn48ioCAUZXX
        Twq0OtwgeAieh8GedIgSTw/y54V0
X-Google-Smtp-Source: ADFU+vseVsSSieQJRa5AneHGAjY4U2GyG1vV+5VztkMR1npYFfitZgwAHoccfLlVnII9dg4y8imQgg==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr4051638wmi.37.1583240644595;
        Tue, 03 Mar 2020 05:04:04 -0800 (PST)
Received: from linux.local ([199.203.162.213])
        by smtp.gmail.com with ESMTPSA id w17sm2171951wrm.92.2020.03.03.05.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:04:04 -0800 (PST)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v1 0/3] x86/kvm/hyper-v: add support for synthetic debugger
Date:   Tue,  3 Mar 2020 15:03:53 +0200
Message-Id: <20200303130356.50405-1-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for the synthetic debugger interface of hyper-v, the
synthetic debugger has 2 modes.
1. Use a set of MSRs to send/recv information
2. Use hypercalls

The first mode is based the following MSRs:
1. Control/Status MSRs which either asks for a send/recv .
2. Send/Recv MSRs each holds GPA where the send/recv buffers are.
3. Pending MSR, holds a GPA to a PAGE that simply has a boolean that
   indicates if there is data pending to issue a recv VMEXIT.

In the first patch the first mode is being implemented in the sense that
it simply exits to user-space when a control MSR is being written and
when the pending MSR is being set, then it's up-to userspace to
implement the rest of the logic of sending/recving.

In the second mode instead of using MSRs KNet will simply issue
Hypercalls with the information to send/recv, in this mode the data
being transferred is UDP encapsulated, unlike in the previous mode in
which you get just the data to send.

The new hypercalls will exit to userspace which will be incharge of
re-encapsulating if needed the UDP packets to be sent.

There is an issue though in which KDNet does not respect the hypercall
page and simply issues vmcall/vmmcall instructions depending on the cpu
type expecting them to be handled as it a real hypercall was issued.

Jon Doron (3):
  x86/kvm/hyper-v: Add support for synthetic debugger capability
  x86/kvm/hyper-v: enable hypercalls regardless of hypercall page
  x86/kvm/hyper-v: Add support for synthetic debugger via hypercalls

 arch/x86/include/asm/hyperv-tlfs.h |  21 +++++
 arch/x86/include/asm/kvm_host.h    |  11 +++
 arch/x86/kvm/hyperv.c              | 122 ++++++++++++++++++++++++++++-
 arch/x86/kvm/hyperv.h              |   5 ++
 arch/x86/kvm/trace.h               |  22 ++++++
 arch/x86/kvm/x86.c                 |   8 ++
 include/uapi/linux/kvm.h           |   9 +++
 7 files changed, 197 insertions(+), 1 deletion(-)

-- 
2.24.1

