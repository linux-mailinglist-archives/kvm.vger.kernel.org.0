Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69DEF19CB48
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 22:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388709AbgDBUgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 16:36:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37591 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgDBUgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 16:36:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id x1so1792126plm.4
        for <kvm@vger.kernel.org>; Thu, 02 Apr 2020 13:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=5Tvvg+jX0GG9uHDoaYNmJitk6pKLfYUjlwPpA4nOY8c=;
        b=h/TL51fwxBfbFddA9eXzFEK5DtH/YBEal9qplDsoh3mxwYkcQE2z1eJ5U3z+3lh5Bq
         VLfCqQDeRi83OHvScQvnNm7luL6VtmLoEkbjTcpwqjPPvq2hCfNPT3SXFzOQT/piwXXH
         T0NqBW+H0T9F8TTmOtrdr+SlwvZhvEszkuTUe2yiKGFFXO3yivBeiZCFKCgor6wO9RHF
         BaH2hIyZwICXGZKQOoh8NmHFTGePT7fHHhXVVQ5bOJ6qwCmH6aTzXeNZ3H6x8+EJRYnS
         3z0ND3iDD0zJ+0pM/YqgDE+4XT4jqtoOIkpj+AynzrjLvT07RRlb9YCnYhDNabv2GKNi
         Sg3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=5Tvvg+jX0GG9uHDoaYNmJitk6pKLfYUjlwPpA4nOY8c=;
        b=eoZswY5xe04+FNA69vUOxK3BZS9yEf18vs+u6TRbvQEPygEA2yPPfaAUL6Dh3/rjSP
         6Ok/itJaCYSU7V+BgqIAFAx+Rs68XQQJHiaFgXgaVz76BL5RV118tJFxO4NelxUdfYND
         rbdf+U45y4sh8wzXCdV0+9VxF1qKfjh8CR34douM59YqU43S0nbyj72qDJuUB66qPLqu
         xmaQTKwo1M1KNM6oIoMYeIVSrT/X95GGo88gFeblNhP4br730/1l/QECslcPNudsLZzD
         pGIULBPRVfRKMjFEy7ukkmC78R4GAbKRglsJbn/OOso1sgu/UFSuZTchjGjBjN+fDksh
         3thg==
X-Gm-Message-State: AGi0PubXJpDKIPyKuC1PgaslgciKDJENHf6mrGO5FNPCvw+rR5WlQG4I
        Td0zX5cDSk6y1JwV95JXdKTV3w==
X-Google-Smtp-Source: APiQypJwwiuCucj4ZpH3FL5V1GUvNK9TzMm3eb1wW/iOjUU0tRn1Sb/G6pQHUNrpI8dDCEvBaDVd/A==
X-Received: by 2002:a17:90a:e64e:: with SMTP id ep14mr5954301pjb.149.1585859770830;
        Thu, 02 Apr 2020 13:36:10 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:20df:efa9:6ad3:9221? ([2601:646:c200:1ef2:20df:efa9:6ad3:9221])
        by smtp.gmail.com with ESMTPSA id y207sm4428233pfb.189.2020.04.02.13.36.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 13:36:10 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 3/3] KVM: VMX: Extend VMX's #AC interceptor to handle split lock #AC in guest
Date:   Thu, 2 Apr 2020 13:36:08 -0700
Message-Id: <D6B8E21D-6DB2-4DF8-8B73-12DD36476F55@amacapital.net>
References: <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, "Kenneth R . Crudup" <kenny@panix.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Nadav Amit <namit@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87h7y1mz2s.fsf@nanos.tec.linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
X-Mailer: iPhone Mail (17D50)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 2, 2020, at 1:07 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20

>=20
>=20
> TBH, the more I learn about this, the more I tend to just give up on
> this whole split lock stuff in its current form and wait until HW folks
> provide something which is actually usable:
>=20
>   - Per thread
>   - Properly distinguishable from a regular #AC via error code

Why the latter?  I would argue that #AC from CPL3 with EFLAGS.AC set is almo=
st by construction not a split lock. In particular, if you meet these condit=
ions, how exactly can you do a split lock without simultaneously triggering a=
n alignment check?  (Maybe CMPXCHG16B?

>=20
> OTOH, that means I won't be able to use it before retirement. Oh well.
>=20
> Thanks,
>=20
>        tglx
