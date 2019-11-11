Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA92F7837
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfKKP6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:58:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37772 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726902AbfKKP6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:58:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573487914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=/zG3yoOFQ60fgDUu8iKgwOvLofe+T2ZT+OEjsdj3fPg=;
        b=O2EKXZ6u1/DY7o3DsNRk4yZY0zXVtoqxeX0NQJOyb1N+/PsTCcvHQNyw+MKuQb9USPtDQ3
        lD0oUbMOjmz5X/GvAeR1mRmmaEg+LiHHcNGsyn2KGrkbG7pBGlWmveDbVP3RuGzT6vfN3k
        kJ1ER5boN2fWiffRdQaNmD8wU7mbVK0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-XkxVwxuFPNyTCVhildMu6g-1; Mon, 11 Nov 2019 10:58:33 -0500
Received: by mail-wr1-f70.google.com with SMTP id j17so10211240wru.13
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 07:58:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F+pHRgddGzkdWCbCt4gYbg2WEhYZkSyJrPGHwvy6a9c=;
        b=bd0WJUwwyHQ2Wymrcwza09Cr8pSQdJiKq1G6zLUi7vxU4a0FG8+pzHBsohNwEvziy4
         qvCBvm2HPp+ZQO8kAnkCyrV5zorbeUWv+3GvS98NvVZjxJTg4r83Nn3MQhfjPcO1Z1Fs
         mNNaKA7m66l2yZzhywic5eBgstat5TEVlZ2Yem6jCrjEjE/XhLy8UEvZWXAvmE1ZoXUm
         +Kl2iXeU1B9aIWfm8sYYt3ec4++QYUMjnYQV3yrF2S3mwbaw0ntmgdee+Z12iPLkMH5J
         tXgB8OXpdtHr1unAVN4YqiSqC2qz8GCf6QCIdAN8usA3OLAH6SQYStUNI7Bo9cshgXFz
         nCdw==
X-Gm-Message-State: APjAAAXH1Y6g8v2GqJAsBbu2O0UmZDKoiavHlOlZOlv0KeQuQx7ovVxe
        GD3nZloUr2fzp8Rl1GHGM43w8w8OlsbL0D1UxHrt3jUbAorUSE9kR6lTEGdtf7IndH+sQmRHf2k
        hRrQnCRTd3078
X-Received: by 2002:a5d:4684:: with SMTP id u4mr16878020wrq.352.1573487912239;
        Mon, 11 Nov 2019 07:58:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqxw608qPouIK70cqcZgnAxYAHqrbWvSLLa0LOs7sqcaAEh0bFhnzAfOp3FrLOC4KyShX/8xbw==
X-Received: by 2002:a5d:4684:: with SMTP id u4mr16877997wrq.352.1573487911940;
        Mon, 11 Nov 2019 07:58:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id w17sm8727264wrt.45.2019.11.11.07.58.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 07:58:31 -0800 (PST)
Subject: Re: [PATCH v1 1/3] KVM: VMX: Consider PID.PIR to determine if vCPU
 has pending interrupts
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-2-joao.m.martins@oracle.com>
 <67bca655-fea3-4b57-be3c-7dc58026b5d9@redhat.com>
 <030dd147-8c4f-d6e3-85a8-ee743ce4d5b0@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5ee4c4ae-9d22-d560-bb61-e5f40b56da2e@redhat.com>
Date:   Mon, 11 Nov 2019 16:58:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <030dd147-8c4f-d6e3-85a8-ee743ce4d5b0@oracle.com>
Content-Language: en-US
X-MC-Unique: XkxVwxuFPNyTCVhildMu6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 15:59, Joao Martins wrote:
>> Should we check the bitmap only if SN is false?
                                            ^^^^^

Of course it should be skipped if SN is false, as you correctly say below.

>> We have a precondition
>> that if SN is clear then non-empty PIR implies ON=3D1 (modulo the small
>> window in vmx_vcpu_pi_load of course), so that'd be a bit faster.
> Makes sense;
>=20
> The bitmap check was really meant for SN=3D1.
>=20
> Should SN=3D0 we would be saving ~22-27 cycles as far as I micro-benchmar=
ked a few
> weeks ago. Now that you suggest it, it would be also good for older platf=
orms too.

Or even newer platforms if they don't use VT-d.

Paolo

