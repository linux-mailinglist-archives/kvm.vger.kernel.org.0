Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325FC2FC45F
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 00:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbhASXCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 18:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbhASXCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 18:02:04 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB67C061575
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:01:24 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 34so10688017otd.5
        for <kvm@vger.kernel.org>; Tue, 19 Jan 2021 15:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRg+gvvJ51JW9K/A8QugB/Fho1kaOXX/fvnAP5LcPtA=;
        b=dw0w/4+KcEr8/9RT46PMqWBwFWdI49Mw6b591ShgUh69zPzoznsm8bK+rG6+p0ic0j
         t86NWdwEp6/SatFbQYlwCAdE+G0KGsTkh1P10SfHwofcbLGPvrUsEzqzrjhVjhxK6Zkh
         m6TcZaoxp88AL3fZWlHZUo+DmhRSZncgIX6FR4pUKs5n61ZO1tFM5rbYKJfWOXdCpqZA
         u907jWVl2wjQ2enpdcgm97TF86DsPHEu91nE6o/pkicbFTmYrgzWeAXNTX8nXUefIIob
         /HolFNaZ0Vyy4tValq1p5Uutw2yFSdBko/Ptpg40IhVXYl0jCJQ73L1Jkpuehp4CazAn
         pxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRg+gvvJ51JW9K/A8QugB/Fho1kaOXX/fvnAP5LcPtA=;
        b=Cx+25LshFtXZBPL/KUUkNIDwvG7+g2/5IypL3wpXSLyberNlGcoCVooztsvQod8XD5
         G/rgk9oul2YDe8to8vO5kSTrraQy0in/C1H1xsnO/S7afqH28Z/Z3K1TWv2PAQ0w/1wU
         TTopmgf9JFy9s/Z/mKBzw6yK2G6T1M8ZcaBA7sU2bveaPHqg2/aIAaSpWWW77s0sSK/g
         HEM/syidfi5SLj99VUZKGjKlZ/DvzFm0ddIpD8pzXxGv8WP7t/ik4JyMwbkUf47wip+Z
         OrTOXDYjwqC4csNhgXGCuwcaCtuuocsVFEq+2JWeG95qNjPlEP4U753yIZb/cWgWFaUB
         s0hg==
X-Gm-Message-State: AOAM530xlcnS8voGLfyeuXWA6ZT3r7IOGxqvz6UHDibI9Uv2fEC051e1
        Zc8GLEFAC+Miwzqzm/1AlCkc71qb2BRhB0I1kJhnig==
X-Google-Smtp-Source: ABdhPJyoRx9I8d0VSaGzEknDnwFi70F1f7k4SQ1ZkNh6WMhNycm3BLi/rwGxz39ygAIHj8yvg7StJ2Ae8tGj1E6bSYg=
X-Received: by 2002:a05:6830:143:: with SMTP id j3mr5106649otp.241.1611097283745;
 Tue, 19 Jan 2021 15:01:23 -0800 (PST)
MIME-Version: 1.0
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com> <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
In-Reply-To: <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 19 Jan 2021 15:01:12 -0800
Message-ID: <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: multipart/mixed; boundary="0000000000004c527205b948d11d"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--0000000000004c527205b948d11d
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:

> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
> as expected.

Debian 9 does not like this patch set. As a kvm guest, it panics on a
Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
please see the attached kernel log snippet. Debian 10 is fine, so I
assume this is a guest bug.

--0000000000004c527205b948d11d
Content-Type: application/octet-stream; name="debian9.panic"
Content-Disposition: attachment; filename="debian9.panic"
Content-Transfer-Encoding: base64
Content-ID: <f_kk4lo2930>
X-Attachment-Id: f_kk4lo2930

WyAgICAxLjIzNTcyNl0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgICAg
MS4yMzc1MTVdIGtlcm5lbCBCVUcgYXQgL2J1aWxkL2xpbnV4LWRxblJTYy9saW51eC00LjkuMjI4
L2FyY2gveDg2L2tlcm5lbC9hbHRlcm5hdGl2ZS5jOjcwOSEKWyAgICAxLjI0MDkyNl0gaW52YWxp
ZCBvcGNvZGU6IDAwMDAgWyMxXSBTTVAKWyAgICAxLjI0MzMwMV0gTW9kdWxlcyBsaW5rZWQgaW46
ClsgICAgMS4yNDQ1ODVdIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVk
IDQuOS4wLTEzLWFtZDY0ICMxIERlYmlhbiA0LjkuMjI4LTEKWyAgICAxLjI0NzY1N10gSGFyZHdh
cmUgbmFtZTogR29vZ2xlIEdvb2dsZSBDb21wdXRlIEVuZ2luZS9Hb29nbGUgQ29tcHV0ZSBFbmdp
bmUsIEJJT1MgR29vZ2xlIDAxLzAxLzIwMTEKWyAgICAxLjI1MTI0OV0gdGFzazogZmZmZjkwOTM2
M2U5NDA0MCB0YXNrLnN0YWNrOiBmZmZmYTQxYmMwMTk0MDAwClsgICAgMS4yNTM1MTldIFJJUDog
MDAxMDpbPGZmZmZmZmZmOGZhMmU0MGM+XSAgWzxmZmZmZmZmZjhmYTJlNDBjPl0gdGV4dF9wb2tl
KzB4MThjLzB4MjQwClsgICAgMS4yNTY1OTNdIFJTUDogMDAxODpmZmZmYTQxYmMwMTk3ZDkwICBF
RkxBR1M6IDAwMDEwMDk2ClsgICAgMS4yNTg2NTddIFJBWDogMDAwMDAwMDAwMDAwMDAwZiBSQlg6
IDAwMDAwMDAwMDEwMjA4MDAgUkNYOiAwMDAwMDAwMGZlZGEzMjAzClsgICAgMS4yNjEzODhdIFJE
WDogMDAwMDAwMDAxNzhiZmJmZiBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiBmZmZmZmZmZmZm
NTdhMDAwClsgICAgMS4yNjQxNjhdIFJCUDogZmZmZmZmZmY4ZmJkM2VjYSBSMDg6IDAwMDAwMDAw
MDAwMDAwMDAgUjA5OiAwMDAwMDAwMDAwMDAwMDAzClsgICAgMS4yNjY5ODNdIFIxMDogMDAwMDAw
MDAwMDAwMDAwMyBSMTE6IDAwMDAwMDAwMDAwMDAxMTIgUjEyOiAwMDAwMDAwMDAwMDAwMDAxClsg
ICAgMS4yNjk3MDJdIFIxMzogZmZmZmE0MWJjMDE5N2RjZiBSMTQ6IDAwMDAwMDAwMDAwMDAyODYg
UjE1OiBmZmZmZWQxYzQwNDA3NTAwClsgICAgMS4yNzI1NzJdIEZTOiAgMDAwMDAwMDAwMDAwMDAw
MCgwMDAwKSBHUzpmZmZmOTA5MzY2MzAwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAK
WyAgICAxLjI3NTc5MV0gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4
MDA1MDAzMwpbICAgIDEuMjc4MDMyXSBDUjI6IDAwMDAwMDAwMDAwMDAwMDAgQ1IzOiAwMDAwMDAw
MDEwYzA4MDAwIENSNDogMDAwMDAwMDAwMDM2MDZmMApbICAgIDEuMjgwODE1XSBTdGFjazoKWyAg
ICAxLjI4MTYzMF0gIGZmZmZmZmZmOGZiZDNlY2EgMDAwMDAwMDAwMDAwMDAwNSBmZmZmYTQxYmMw
MTk3ZTAzIGZmZmZmZmZmOGZiZDNlY2IKWyAgICAxLjI4NDY2MF0gIDAwMDAwMDAwMDAwMDAwMDAg
MDAwMDAwMDAwMDAwMDAwMCBmZmZmZmZmZjhmYTJlODM1IGNjZmZmZmZmOGZhZDQzMjYKWyAgICAx
LjI4NzcyOV0gIDFjY2QwMjMxODc0ZDU1ZDMgZmZmZmZmZmY4ZmJkM2VjYSBmZmZmYTQxYmMwMTk3
ZTAzIGZmZmZmZmZmOTAyMDM4NDQKWyAgICAxLjI5MDg1Ml0gQ2FsbCBUcmFjZToKWyAgICAxLjI5
MTc4Ml0gIFs8ZmZmZmZmZmY4ZmJkM2VjYT5dID8gc3dhcF9lbnRyeV9mcmVlKzB4MTJhLzB4MzAw
ClsgICAgMS4yOTQ5MDBdICBbPGZmZmZmZmZmOGZiZDNlY2I+XSA/IHN3YXBfZW50cnlfZnJlZSsw
eDEyYi8weDMwMApbICAgIDEuMjk3MjY3XSAgWzxmZmZmZmZmZjhmYTJlODM1Pl0gPyB0ZXh0X3Bv
a2VfYnArMHg1NS8weGUwClsgICAgMS4yOTk0NzNdICBbPGZmZmZmZmZmOGZiZDNlY2E+XSA/IHN3
YXBfZW50cnlfZnJlZSsweDEyYS8weDMwMApbICAgIDEuMzAxODk2XSAgWzxmZmZmZmZmZjhmYTJi
NjRjPl0gPyBhcmNoX2p1bXBfbGFiZWxfdHJhbnNmb3JtKzB4OWMvMHgxMjAKWyAgICAxLjMwNDU1
N10gIFs8ZmZmZmZmZmY5MDczZTgxZj5dID8gc2V0X2RlYnVnX3JvZGF0YSsweGMvMHhjClsgICAg
MS4zMDY3OTBdICBbPGZmZmZmZmZmOGZiODFkOTI+XSA/IF9fanVtcF9sYWJlbF91cGRhdGUrMHg3
Mi8weDgwClsgICAgMS4zMDkyNTVdICBbPGZmZmZmZmZmOGZiODIwNmY+XSA/IHN0YXRpY19rZXlf
c2xvd19pbmMrMHg4Zi8weGEwClsgICAgMS4zMTE2ODBdICBbPGZmZmZmZmZmOGZiZDdhNTc+XSA/
IGZyb250c3dhcF9yZWdpc3Rlcl9vcHMrMHgxMDcvMHgxZDAKWyAgICAxLjMxNDI4MV0gIFs8ZmZm
ZmZmZmY5MDc3MDc4Yz5dID8gaW5pdF96c3dhcCsweDI4Mi8weDNmNgpbICAgIDEuMzE2NTQ3XSAg
WzxmZmZmZmZmZjkwNzcwNTBhPl0gPyBpbml0X2Zyb250c3dhcCsweDhjLzB4OGMKWyAgICAxLjMx
ODc4NF0gIFs8ZmZmZmZmZmY4ZmEwMjIzZT5dID8gZG9fb25lX2luaXRjYWxsKzB4NGUvMHgxODAK
WyAgICAxLjMyMTA2N10gIFs8ZmZmZmZmZmY5MDczZTgxZj5dID8gc2V0X2RlYnVnX3JvZGF0YSsw
eGMvMHhjClsgICAgMS4zMjMzNjZdICBbPGZmZmZmZmZmOTA3M2YwOGQ+XSA/IGtlcm5lbF9pbml0
X2ZyZWVhYmxlKzB4MTZiLzB4MWVjClsgICAgMS4zMjU4NzNdICBbPGZmZmZmZmZmOTAwMTFkNTA+
XSA/IHJlc3RfaW5pdCsweDgwLzB4ODAKWyAgICAxLjMyNzk4OV0gIFs8ZmZmZmZmZmY5MDAxMWQ1
YT5dID8ga2VybmVsX2luaXQrMHhhLzB4MTAwClsgICAgMS4zMzAwOTJdICBbPGZmZmZmZmZmOTAw
MWY0MjQ+XSA/IHJldF9mcm9tX2ZvcmsrMHg0NC8weDcwClsgICAgMS4zMzIzMTFdIENvZGU6IDAw
IDBmIGEyIDRkIDg1IGU0IDc0IDRhIDBmIGI2IDQ1IDAwIDQxIDM4IDQ1IDAwIDc1IDE5IDMxIGMw
IDgzIGMwIDAxIDQ4IDYzIGQwIDQ5IDM5IGQ0IDc2IDMzIDQxIDBmIGI2IDRjIDE1IDAwIDM4IDRj
IDE1IDAwIDc0IGU5IDwwZj4gMGIgNDggODkgZWYgZTggZGEgZDYgMTkgMDAgNDggOGQgYmQgMDAg
MTAgMDAgMDAgNDggODkgYzMgZTggClsgICAgMS4zNDI4MThdIFJJUCAgWzxmZmZmZmZmZjhmYTJl
NDBjPl0gdGV4dF9wb2tlKzB4MThjLzB4MjQwClsgICAgMS4zNDU4NTldICBSU1AgPGZmZmZhNDFi
YzAxOTdkOTA+ClsgICAgMS4zNDcyODVdIC0tLVsgZW5kIHRyYWNlIDBhMWM1YWI1ZWIxNmRlODkg
XS0tLQpbICAgIDEuMzQ5MTY5XSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVk
IHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDEuMzQ5MTY5XSAKWyAgICAx
LjM1Mjg4NV0gS2VybmVsIE9mZnNldDogMHhlYTAwMDAwIGZyb20gMHhmZmZmZmZmZjgxMDAwMDAw
IChyZWxvY2F0aW9uIHJhbmdlOiAweGZmZmZmZmZmODAwMDAwMDAtMHhmZmZmZmZmZmJmZmZmZmZm
KQpbICAgIDEuMzU3MDM5XSAtLS1bIGVuZCBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0
ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9MHgwMDAwMDAwYgpbICAgIDEuMzU3MDM5XSAK
--0000000000004c527205b948d11d--
