Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69A510427C
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbfKTRtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 12:49:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728342AbfKTRtk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Nov 2019 12:49:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574272178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=AwplhFvZn7ue8kuvSWisJ2pQUAairzqRsfTIC3ok1HE=;
        b=ILCfn4A56pe5FlIqDpivqqaGlxbZAox/2UZpc+UiH+XNC0hw2RRlvIf+Jx5GllwkRyKDiR
        8VZyq7e2GFs2omKeKeM/JA+B+mvcgjcf0LkegRfPEWzm5zRAoeNZ1ILuBrfbEMey3f5QMS
        eYeTGHt3xo27D/SQIaDs8HQqkahGubM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-DmtL5hSsPtm1c_0e4SdTBQ-1; Wed, 20 Nov 2019 12:49:34 -0500
Received: by mail-wm1-f69.google.com with SMTP id q186so85696wma.0
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 09:49:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=akAVd8K6cQxkBf+QkTljJ+ZWGqQSUCB1thlOsQO/Xic=;
        b=QKj9CrJdNxSTagZzUVWX9ZMY9AvBuSvc01H/IFYsn4If2OZmHmcE5SHl5OfYWFoFM1
         i8RkFuiw5zSTGgs5XoEJqO/4QZpJPt1ZaWeMZUDDTnr9agZySaYXFdWTGvzCaWlQIk/k
         psGku6jZivR6aygGL/X2Mmu1LuW0KQRwVG+TLSlL5IsWAk2ip8/N/ySPf3NL0PalgbAi
         h0fClt2iTP8x/30Qczj0KiaLc4fBnbVsWGTX+CU9TGU9ZVETD/Z0vQDD9bt0XJKX67U2
         cQSEZFzGcYhcAl6+QWYnY0vBw+kNMR+uvZXnDZO73zcSiEXaOEQafIkO28NHKlpU1wkh
         6jlQ==
X-Gm-Message-State: APjAAAVwz5AZAY6gx0qUOmqWBDzfTwUl3INN1MW1YH3ZUygPUAeh/J+L
        lla1Tm1kaJ5LyY5I8wLFXn2DeJS78UERNBJI9e0szyc8+JxAPirKP1vXg4T5duSa+c7I8BCjDNM
        POcaBlHM3J0cw
X-Received: by 2002:adf:dd10:: with SMTP id a16mr5201010wrm.213.1574272172835;
        Wed, 20 Nov 2019 09:49:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQiaNhRCqA3U7hrirHolgRGh8UguIsTmZtRpD8Pnntcu9SeilEx815TpiMjKR5npbWyAaaMQ==
X-Received: by 2002:adf:dd10:: with SMTP id a16mr5200964wrm.213.1574272172477;
        Wed, 20 Nov 2019 09:49:32 -0800 (PST)
Received: from [192.168.178.40] ([151.48.115.61])
        by smtp.gmail.com with ESMTPSA id z6sm30941wro.18.2019.11.20.09.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:49:32 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Remove unnecessary TLB flushes on L1<->L2
 switches when L1 use apic-access-page
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191120143307.59906-1-liran.alon@oracle.com>
 <d7d4629a-c605-72bc-9d71-dd97cb6c0ab4@redhat.com>
 <4D796E12-758F-44D6-93B9-0BEFE0E7F712@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92baadfa-b458-7a12-25c4-da198b64e8c7@redhat.com>
Date:   Wed, 20 Nov 2019 18:49:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4D796E12-758F-44D6-93B9-0BEFE0E7F712@oracle.com>
Content-Language: en-US
X-MC-Unique: DmtL5hSsPtm1c_0e4SdTBQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 16:25, Liran Alon wrote:
>>> If L0 use EPT, L0 use different EPTP when running L2 than L1
>>> (Because guest_mode is part of mmu-role) and therefore SDM section
>>> 28.3.3.4 doesn't apply. Otherwise, L0 use different VPID when
>>> running L2 than L1 and therefore SDM section 28.3.3.3 doesn't
>>> apply.
>> I don't understand this.  You could still have a stale EPTP entry from a
>> previous L2 vmenter.   If L1 uses neither EPT nor VPID, it expects a TLB
>> flush to occur on every vmentry, but this won't happen if L0 uses EPT.
> I don=E2=80=99t seem to get your concern.
> In case L1 don=E2=80=99t use VPID, prepare_vmcs02() will request KVM_REQ_=
TLB_FLUSH.
> (As it needs to emulate to L1 that on every L1<->L2 switch, the entire ph=
ysical TLB is flushed)
> As explained in commit message.
>=20

You're right.  I'll rewrite some parts of the commit message, but the
patch is correct.

Paolo

