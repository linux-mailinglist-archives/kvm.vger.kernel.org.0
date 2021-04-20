Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97195365C59
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhDTPkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 11:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53004 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233022AbhDTPkN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 11:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618933181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=coXw7bSB92l2OSOi2Pskhossq8vZZCyQYfDdNtE51LI=;
        b=dOEt/yAUasv/0PvUhQPYQRPHrt8eAJsHHfxMsqZjwqDAwnLaT9wo4QUU7Ob8ZKwxCrwexi
        fcaI5VnjjghSSnk5ieVBYKwN7Z8XDky6OEz4spGE9peVlXlBsHSPBrSWTCsUaz2FYUHWCQ
        c6uHCRHAcnBqzi0jncO+6YACboNFuHE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-D5jmD-_QNS-TNVQZfn9jwA-1; Tue, 20 Apr 2021 11:39:32 -0400
X-MC-Unique: D5jmD-_QNS-TNVQZfn9jwA-1
Received: by mail-qv1-f70.google.com with SMTP id m19-20020a0cdb930000b029019a25080c40so11634892qvk.11
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 08:39:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=coXw7bSB92l2OSOi2Pskhossq8vZZCyQYfDdNtE51LI=;
        b=mH1kkGrMB/LBSNUwbZ5BU444G4lf/UEePA9Z+aAZl7hfcEltZPHCGS++jiOw3m5YJ7
         m2aydhSmsT6rCNpT+hL2x3rr/nEdE+ay3Qd8Oym0td+wxY4xl5xvf8NdB0/iiEKJC/m2
         4bLpGN67s0Qy7Xw89XSr10KE4J2pla/t9oww1BveWQeTCoB6t8X62+DgXc67Ye/eJfIy
         UhQdxUXOw28Wv9+UsCXehhA4YUgWJNFjREdtQLsU5e2Y6G19Jc+446q3H6zknXorVCfv
         aHVEBWYYnJ3cTAqIIXkyERxiyRqr+tvYStu6rubfx5TdUIHXFrqYjkBjadkif1cQVFQ7
         8EOA==
X-Gm-Message-State: AOAM530WtdXRyUN5D1ZVf5X8yjicHXtG3jhoKznvABabwAH1XknBn9t9
        mXA9PRFjG+rma+sDsyfJst6eb+ro2+ME76hFeqjnjXzTLpcYV7hYiUkii6KK81AxOugTpbdgHoD
        JIkNbvsDXjOUyhWM2me7gLBlaqn+Vbgt54IUAigRhxZOp5QdV4q5aqWZjzrIMyg==
X-Received: by 2002:ac8:4e16:: with SMTP id c22mr10856584qtw.354.1618933171911;
        Tue, 20 Apr 2021 08:39:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE/oMaWgtfj/To4K6pA6L6aSzn9oP92etGjIRHkk4pGYIgEbMrwLhaCy0IueXIi8VP6xiH0Q==
X-Received: by 2002:ac8:4e16:: with SMTP id c22mr10856551qtw.354.1618933171631;
        Tue, 20 Apr 2021 08:39:31 -0700 (PDT)
Received: from xz-x1.redhat.com (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id f12sm11633325qtq.84.2021.04.20.08.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:39:31 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v4 0/2] KVM: selftests: fix races in dirty log test
Date:   Tue, 20 Apr 2021 11:39:27 -0400
Message-Id: <20210420153929.482810-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4:=0D
- add missing vcpu_handle_sync_stop() call in dirty ring test=0D
=0D
The other solution of patch 2 is here [1]=0D
=0D
I got another report that there seems to still be a race, but that one seem=
s=0D
extremely hard to trigger, even so far we don't know whether that could be=
=0D
ARM-only.  Since current fix should make sense already and fix real problem=
s,=0D
IMHO we don't need to wait for that.=0D
=0D
Paolo, I still kept the 2nd patch just for completeness, but feel free to=0D
ignore the 2nd patch if you prefer the other version, and I'll follow your=
=0D
preference.=0D
=0D
Thanks!=0D
=0D
[1] https://lore.kernel.org/kvm/20210420081614.684787-1-pbonzini@redhat.com=
/=0D
=0D
Peter Xu (2):=0D
  KVM: selftests: Sync data verify of dirty logging with guest sync=0D
  KVM: selftests: Wait for vcpu thread before signal setup=0D
=0D
 tools/testing/selftests/kvm/dirty_log_test.c | 70 +++++++++++++++++---=0D
 1 file changed, 59 insertions(+), 11 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

