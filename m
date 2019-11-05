Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A45F04B7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 19:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390643AbfKESHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 13:07:53 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:44611 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390594AbfKESHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 13:07:53 -0500
Received: by mail-il1-f194.google.com with SMTP id i6so441877ilr.11
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 10:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zezTaiEqq1UtRotdJwAqGvetO46p8s+3o0em/9FPHcQ=;
        b=HsGXXXZj69GJEwSS88pf05aKAYNxorRasJtLezyB6CHnTFXEDxkLnVNX9aEliz2PIM
         pWlCmuBF2ZwFanCSRPV04cNQALd0bnFtDhnR+YbAuR8PQqwaqgNMorPjp/yq9b8C+uCR
         5jAjmnmcpSrehT51XjuOYx5h2XZHLvktqFMUe0q81hugUkXYg1AN1LMTLNqAI7f3e/CP
         P/QrLFmPxgYZtpQuqZbjvR7jawiJiYrLvnAAfHUFITwfjHAV0cXbYj/WSnzW9o9aETHT
         3+V3gqdBNHP+DK631+grZQ5zhfUXmAtZ3/3QuC+skf+9yrwqKSzQUXOUgIe1OrqpoLA3
         aPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zezTaiEqq1UtRotdJwAqGvetO46p8s+3o0em/9FPHcQ=;
        b=pH4ZEYyDqPAGEX0mrnoFOmCkQ9Qgf/l4dz7gDwhVBHm6qsyctW8RO6nfp0TWCwnDdB
         kHxhCrikCcEujfOgpWb8cN0fu/2VR3WEaEzO0/QmV1uBIXicvIHcDH48XFRrydobvEWE
         XxB2Q7GgUJVwupzvGY7ae0Et1BaBHOfjZn+kGDQGOa8wJ5zzAyr1gIBcoJvVNNCo5BiA
         mu4pgu0HhdMVaiE0O2OJ2wpc+5TuKGzSBaEWVB83kr5w1OTEaKBXBzNG2wug4NGDvo0N
         3yTSLWFAS4cTqTkBbrcNSg7QNS0n/25AcmaHcyOYZ6oFsA8NM6lf5uY36W3B39xauppy
         PC1g==
X-Gm-Message-State: APjAAAXo5iSZubRJPNA8/+eMDWx8HSdbbiDrYLcGfQD1htEu/TGT9aJE
        Wv+yr2fKsU8wBkfsmZhFjjQxLXpTDz1wBpOkRlmLOA==
X-Google-Smtp-Source: APXvYqw++IYZUGogoYks+6M1BIyFNVI9hFOgzJpSxwWNM0PrSUf8KL7YoeGeoMgex2szvsu1E+BzNHCULYP9A1GDAsk=
X-Received: by 2002:a92:9ace:: with SMTP id c75mr11792602ill.296.1572977270320;
 Tue, 05 Nov 2019 10:07:50 -0800 (PST)
MIME-Version: 1.0
References: <20191101203353.150049-1-morbo@google.com> <20191101203353.150049-2-morbo@google.com>
 <119b3e09-1907-5c7f-7c47-753ce7effe23@redhat.com>
In-Reply-To: <119b3e09-1907-5c7f-7c47-753ce7effe23@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 5 Nov 2019 10:07:39 -0800
Message-ID: <CALMp9eTUgxB5+K-eun-NXKdQbaObBFJDaL6r5=A3myoW4ZH4hA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/2] x86: realmode: save and restore %es
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Bill Wendling <morbo@google.com>, kvm list <kvm@vger.kernel.org>,
        thuth@redhat.com, alexandru.elisei@arm.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 4, 2019 at 4:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/11/19 21:33, Bill Wendling wrote:
> > Some of the code test sequences (e.g. push_es) clobber ES. That causes
> > trouble for future rep string instructions. So save and restore ES
> > around the test code sequence in exec_in_big_real_mode.
>
> You mean pop_es.  Applied with that change.

I think push_es and pop_es are both guilty of clobbering %es:

MK_INSN(push_es, "mov $0x231, %bx\n\t" //Just write a dummy value to
see if it gets overwritten
"mov $0x123, %ax\n\t"
"mov %ax, %es\n\t"   <======= Here
"push %es\n\t"
"pop %bx \n\t"
);

MK_INSN(pop_es, "push %ax\n\t"
"pop %es\n\t"          <======== Here
"mov %es, %bx\n\t"
);
