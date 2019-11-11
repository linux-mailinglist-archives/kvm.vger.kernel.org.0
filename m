Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE6F75DB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKKOCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:02:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48129 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbfKKOCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2HTa1ngHuirBrMsL3KLUBSKYu0dq4sOVUTDgb0CAUdc=;
        b=VuMQaY2lewP7huu89A6u6z+RBSREeJCyJ0wrspypBRivUbC65KYLzux2EuNTlH6+ZrXS3O
        BLZXvbw41Nf7l3Z/lobbqa9vkHsBCi+4zjFDKi5Ig6Re0518FAKRR/47R/UPLwqZgSA6AY
        PzcPjEDZW4Vi/9I1Iy6o/cIKl+vMs+I=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-u_n6ZR_iPbah5NwStoe42A-1; Mon, 11 Nov 2019 09:02:30 -0500
Received: by mail-wm1-f69.google.com with SMTP id b10so6906826wmh.6
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 06:02:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XB0qHGYLVcVA1erpwz2Rl7+/5K+EptCTKRytU8bU7Ns=;
        b=oJ9W+Uv4jC+8opC9ECnSZNpn2OhfgWQWwAsAvt2mrSVV8oaJqsjA+QRksShFED89Xs
         0wVKH1t6BrgqUQtqOxVrgcm1WC7FV54ueRtASfSUZ98xMXQ5KkMrgABx+7rnOLg259Ih
         JyTDvuaEot/iwoINQrK7Fm0p68CSMGPSNi9toI/ESzrqRAWYbdydohCC453VnhegM7HE
         reqFUf/M8yNlPHbDvDPQgc/Jq35/brcg61dPVTON7bbw9G063t5YjbWvLVPQHnKtC1BG
         f4dr+cvH4qB7Nj3l0rAWASrDpM5yW9i3GibhMey/sSHmaTfS+onx7pB9hRCsyIErp5nu
         v7fw==
X-Gm-Message-State: APjAAAUZuZ4RzymDcWdo+UDCL/esJg3Ev80rDfkYpj328SSfTq/HAzv4
        RRYgbmG+azpHCNVUK0udcAb5R+TM68GQIOirloKtyMY9B9mzRawtfdJQSFRQPufM14GspScyKWi
        G359wioX4PtoP
X-Received: by 2002:adf:e40e:: with SMTP id g14mr1045407wrm.264.1573480948779;
        Mon, 11 Nov 2019 06:02:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqx4PBRNbIZaeQQFF5KjjrlYnulrE2VpmEQt1a5cEfualJp8M6F7cOxnDKI/3IlL3BClfkFc5g==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr1045388wrm.264.1573480948535;
        Mon, 11 Nov 2019 06:02:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id 5sm13533793wmk.48.2019.11.11.06.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 06:02:28 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: Prevent set vCPU into INIT/SIPI_RECEIVED
 state when INIT are latched
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Mihai Carabas <mihai.carabas@oracle.com>
References: <20191111091640.92660-1-liran.alon@oracle.com>
 <20191111091640.92660-3-liran.alon@oracle.com>
 <cff559e6-7cc4-64f3-bebf-e72dd2a5a3ea@redhat.com>
 <BB5CCF97-38DE-4037-83E3-22E921D25651@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ea6e861f-a293-e0da-6364-547fe23cbab1@redhat.com>
Date:   Mon, 11 Nov 2019 15:02:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BB5CCF97-38DE-4037-83E3-22E921D25651@oracle.com>
Content-Language: en-US
X-MC-Unique: u_n6ZR_iPbah5NwStoe42A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 14:46, Liran Alon wrote:
>> +=09 * INITs are latched while CPU is in specific states
>> +=09 * (SMM, VMX non-root mode, SVM with GIF=3D0).
> I didn=E2=80=99t want this line of comment as it may diverge from the imp=
lementation of kvm_vcpu_latch_init().
> That=E2=80=99s why I removed it.
>=20
>> =09 * Because a CPU cannot be in these states immediately
>> =09 * after it has processed an INIT signal (and thus in
>> =09 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs

Got it... on the other hand knowing the specific states clarifies why
they cannot be in that state immediately after processing INIT.  It's a
bit of a catch-22 indeed.

Paolo

