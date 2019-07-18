Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D92A06CCFD
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 12:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390044AbfGRKtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 06:49:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39954 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfGRKtp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 06:49:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so28136549wrl.7
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 03:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QVm6wTnvvnYzFx7JN+sXZO6XJoq6kmmIjpQZFK3Xqnk=;
        b=V85rBldayXvpQEJBPsXSnMGanvjS/Z6iuENYyP0sQgOGs/luzemmYFIPs3FXp7sZpE
         yInYYsWEaDe5PDMcQ86yQlDEwNvVUup2V0h3Aahat+nskv6/SBKOBKoz/DdD8b9rBvYv
         ndeA1PJmdK17c6cx3o75R9DcxwldM3Wnm+00X0hr/15hH1ubpC5mIxZX3saFEFBeR9Fv
         hp67zTcUx7PY6Iurp2ZMab6+UTEzls286Xo+5hIaEy1S0VJJzVXwFAsYLPAS63Y+EE8u
         HX+OObUuojJvRTTTg/4dNTLJ9ZxqM/VJolWKMZJBplAlVmaLhS1tkAF6JVEgMd1Q6V3z
         MDqg==
X-Gm-Message-State: APjAAAU+15xvEB9X5KtIEApqXfRozDpATqHJQbBBLWA9lae958zdFDUD
        Zk+O4hVLIPHn/R98wTccym/TTw==
X-Google-Smtp-Source: APXvYqxKWPfqJoJuMNPOh2fbhZwTQgCkfz6IKf4I3GF8NNcUnECijQHSZJIngrmyrluMx3+c3TV3Zg==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr47296654wrx.82.1563446983484;
        Thu, 18 Jul 2019 03:49:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id p14sm22542755wrx.17.2019.07.18.03.49.41
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 03:49:42 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: Fix detection of AMD Errata 1096
To:     "Singh, Brijesh" <brijesh.singh@amd.com>,
        Liran Alon <liran.alon@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20190716235658.18185-1-liran.alon@oracle.com>
 <462d7b68-94c9-2e9b-23f8-bc2567fa62af@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d0445fde-afe1-f3fe-6c26-3d8eef8dc4d8@redhat.com>
Date:   Thu, 18 Jul 2019 12:49:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <462d7b68-94c9-2e9b-23f8-bc2567fa62af@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Brijesh,

just one thing I'd like to double check: does the erratum really depend 
on guest CR4.SMAP, or rather on host CR4.SMAP?  (Of course the SMEP 
check instead needs to use guest CR4.SMEP).

And here is a commit message with style fixes:

---
When CPU raise #NPF on guest data access and guest CR4.SMAP=1, it is
possible that CPU microcode implementing DecodeAssist will fail
to read bytes of instruction which caused #NPF. This is AMD errata
1096 and it happens because CPU microcode reading instruction bytes
incorrectly attempts to read code as implicit supervisor-mode data
accesses (that is, just like it would read e.g. a TSS), which are
susceptible to SMAP faults. The microcode reads CS:RIP and if it is
a user-mode address according to the page tables, the processor
gives up and returns no instruction bytes.  In this case,
GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
return 0 instead of the correct guest instruction bytes.

Current KVM code attemps to detect and workaround this errata, but it
has multiple issues:

1) It mistakenly checks if guest CR4.SMAP=0 instead of guest CR4.SMAP=1,
which is required for encountering a SMAP fault.

2) It assumes SMAP faults can only occur when vCPU CPL==3.
However, in case vCPU CR4.SMEP=0, the guest can execute an instruction
which reside in a user-accessible page with CPL<3 priviledge. If this
instruction raise a #NPF on it's data access, then CPU DecodeAssist
microcode will still encounter a SMAP violation.  Even though no sane
OS will do so (as it's an obvious priviledge escalation vulnerability),
we still need to handle this semanticly correct in KVM side.

Note that (2) *is* a useful optimization, because CR4.SMAP=1 is an easy
triggerable condition and guests usually enable SMAP together with SMEP,
If the vCPU has CR4.SMEP=1, the errata could indeed be encountered only
at guest CPL3; otherwise, the CPU would raise a SMEP fault to guest
instead of #NPF.  We keep this condition to avoid false positives in
the detection of the errata.

In addition, to avoid future confusion and improve code readbility,
include details of the errata in code and not just in commit message.
---

Paolo
