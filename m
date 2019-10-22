Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C141DE0608
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbfJVOJL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 10:09:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727582AbfJVOJL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 10:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571753350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=uSxGqEuW52lrWz/8potOYyUverZyGRXQnr3ONuzw9lw=;
        b=ZTqiheduNOxKuaF1PEXI6CVlPLgC3FODuus7f0xYtr91LsBEBlDo6DWYWehFpys1LEynBB
        urorqV9QAcJPEV2FgaHaKUSu9FgYhz3Q2tPDVAtIRpikXsqtuijmDYfUqlflvvZV254lOA
        Z4pVt6ZglXZ3uy3Wcu0binZuGLnZEl4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-0WEG52dyPrisHiO9hrz8qw-1; Tue, 22 Oct 2019 10:09:04 -0400
Received: by mail-wm1-f72.google.com with SMTP id m68so2571932wme.7
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 07:09:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=makMNuKu1ppWLAvCA/QyEUL2D+FfE16R1xUwog6fpcY=;
        b=qsgAkot2vFwTeixLrzi7g2YmXn1eNb1DX0zIAydCaFC6DL7nM47DU/EzQ9pXuTedqA
         zj4iPVnTUTy2/ZZ5y+6JT+eAYkV0yaIPLFA8hyMmQ2RzQqBYJhROX7SU/mFedZC9xXKv
         l3bAffObD/gQiljGC2cImF4FBCaGg5zWv6ZF0nVHCzcyg1dYz0ihPgCbChtxCcva8AwY
         N3cIWnxbbJZcLrZxbHRjgLCBtzo8l/OUjiXmKJNcxNbA7xl/+GXy1DqeyQyaOEqQDTmE
         n64eTSdC1VyUaLU8torImha5Z3URrLkGVjKYIQlfmMMFIjfE+JEp9JWdLfd1VKKFmcZK
         S9mw==
X-Gm-Message-State: APjAAAWZYlNoUCaykT8V79q+BX1P9ZOqGy3XaW2az/Vd0bTN6tfhHFRA
        lKu6hcq5FdciZeSwK8lOAW7c3/ridM0KLKbmCm+cLpHnaZ63hnq7iHEJm5TrnAUmu6jfDiNME81
        aHje72Yh3aJ+i
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr3274028wmb.27.1571753343664;
        Tue, 22 Oct 2019 07:09:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzkJgcR6x3vTLahX+BVgNWIDW6o7sVahp6sEE316gNwH/lVfCALUNph0Wv1M5z5/y2k/6tSsQ==
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr3273996wmb.27.1571753343407;
        Tue, 22 Oct 2019 07:09:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id z125sm25633535wme.37.2019.10.22.07.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 07:09:02 -0700 (PDT)
Subject: Re: [PATCH v3 6/6] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org
Cc:     peterz@infradead.org, like.xu@intel.com,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com, wei.w.wang@intel.com,
        kan.liang@intel.com
References: <20191021160651.49508-1-like.xu@linux.intel.com>
 <20191021160651.49508-7-like.xu@linux.intel.com>
 <c17a9d77-2c30-b3c0-4652-57f0b9252f3b@redhat.com>
 <7d46a902-43eb-4693-f481-1c2efd397fbd@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d3434a16-07ed-7070-f316-9a2fa072ace0@redhat.com>
Date:   Tue, 22 Oct 2019 16:09:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7d46a902-43eb-4693-f481-1c2efd397fbd@linux.intel.com>
Content-Language: en-US
X-MC-Unique: 0WEG52dyPrisHiO9hrz8qw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 14:00, Like Xu wrote:
>=20
> Second, the structure of pmu->pmc_in_use is in the following format:
>=20
> =C2=A0 Intel: [0 .. INTEL_PMC_MAX_GENERIC-1] <=3D> gp counters
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [INTEL=
_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=3D> fixed
> =C2=A0 AMD:=C2=A0=C2=A0 [0 .. AMD64_NUM_COUNTERS-1] <=3D> gp counters

Sorry---I confused INTEL_PMC_MAX_FIXED and INTEL_PMC_IDX_FIXED.

The patches look good, I'll give them another look since I obviously
wasn't very much awake when reviewing them.

Paolo

