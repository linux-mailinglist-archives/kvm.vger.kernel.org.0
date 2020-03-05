Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D7D17A967
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCEP5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:57:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52730 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726184AbgCEP5O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 10:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583423833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IxoeEnt35O7QTmRZWyr2gwugnfgn2HRJVIdogRILp7k=;
        b=dQtCxkPub7SE1lGVzRmyEOJVXWbvZq/fj+FaEgtuHOc1UIPfOUcI3TJKJ5b7A6bvQTUAC+
        WYxzAMSSR46DhjqGNtRHQLuEFud0jr/pSwTioQHRSAtVk4vufNBD1yhVsk4fFsUk4+7vz5
        4JWEdOTlBIqJEsEcz8dFYdCz9ZNmlXY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-FnlzzZx7M2CEOesy1lHj7g-1; Thu, 05 Mar 2020 10:57:12 -0500
X-MC-Unique: FnlzzZx7M2CEOesy1lHj7g-1
Received: by mail-qv1-f71.google.com with SMTP id g11so3294437qvl.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 07:57:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IxoeEnt35O7QTmRZWyr2gwugnfgn2HRJVIdogRILp7k=;
        b=Lu/Jj7l5MWzse23Zep9LEni5M2PueLdIHVva1BlNYpU7GvADPEFqPoDrWWZTqRADYt
         JdPIEIaaR3nmTVzIysWQpf0gndI53L0ILq+q7G4+9M4uFxD277/2Awh7ItXGdEZT85l3
         oqLV9gDXK59FtB5agO7miCveOWltnwkwcAf1uUHkzY15sNVGcC1ecdivDNC6sX34l8uw
         RZerbdltSq6Xlt8zSj22ZJ6Cnoo9vPSXVhlml6Ms39Sxn4oDuIUv/q2DmOybwfMSYJR7
         cFJL5xzh7PBdf7/DTcjCIT8Tu5XJxGiGHQOXw92AJg4eokwI7UB8CJQsJMiSoIdsyZCn
         qn/A==
X-Gm-Message-State: ANhLgQ1MNiTJzYMcvuBFY7STnaReFYJ0bthVlKpworVk1aUmdERtrV/u
        IYjS7HsfPjy3AyQAAYGLi2C1kwqfKos8mB8Wuec+EUks90HRBH2L/BKttZlgvG6+xFzrvOHi0of
        Gn2igK7cQITo5
X-Received: by 2002:a37:6258:: with SMTP id w85mr9019903qkb.206.1583423831397;
        Thu, 05 Mar 2020 07:57:11 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsWJ9ChA7AqjC8mi6Y+3B8RoMTG+j/4BpcKmFtJ6GioCGLGAqBL5bV82PTSSCUwsx+KztqSCw==
X-Received: by 2002:a37:6258:: with SMTP id w85mr9019888qkb.206.1583423831166;
        Thu, 05 Mar 2020 07:57:11 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a18sm14815053qkg.48.2020.03.05.07.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 07:57:10 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmiaohe@huawei.com, Paolo Bonzini <pbonzini@redhat.com>,
        peterx@redhat.com
Subject: [PATCH v2 0/2] KVM: Drop gfn_to_pfn_atomic()
Date:   Thu,  5 Mar 2020 10:57:07 -0500
Message-Id: <20200305155709.118503-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:=0D
- add a document update for indirect sp fast path which referenced=0D
  gfn_to_pfn_atomic(). [linmiaohe]=0D
=0D
Please review, thanks.=0D
=0D
Peter Xu (2):=0D
  KVM: Documentation: Update fast page fault for indirect sp=0D
  KVM: Drop gfn_to_pfn_atomic()=0D
=0D
 Documentation/virt/kvm/locking.rst | 9 ++++-----=0D
 include/linux/kvm_host.h           | 1 -=0D
 virt/kvm/kvm_main.c                | 6 ------=0D
 3 files changed, 4 insertions(+), 12 deletions(-)=0D
=0D
-- =0D
2.24.1=0D
=0D

