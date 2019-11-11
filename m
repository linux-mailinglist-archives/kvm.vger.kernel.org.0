Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E05DF791E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKKQuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:50:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46451 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726889AbfKKQuJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573491009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=OkZ+Vzh7EQWxCTLrI0mNws5Gnmovyu+336FSuRsBdro=;
        b=cRUdCS2rfgTfzP3YaWj7YtORsfm4HnN+7IkmdrLzapnJW05v7OMZKi/FLp/dYpTdG0H/eV
        ALZm/Evr1um+6UT54mIDQRSBerEr/6xSGvCxcSdn2FqqXTsbELhm8Z681jGbY0FwwZ7YzY
        kAEoSXVO2WnXbtRC8p5toD0cHzaSLbc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-raEFigrtO4u3zEryxzc-Jg-1; Mon, 11 Nov 2019 11:50:06 -0500
Received: by mail-wr1-f71.google.com with SMTP id b4so10273966wrn.8
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:50:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+3Ejp316XM3FRrty9ooCy9P9UOvlWptqrl2O+qkSCWo=;
        b=q46H2PGxstp+olo74hmveQdQvXJZIeK9P/u2zO0pKle8MhOKoRa1iOBVwyvwILFVma
         naLY80dKRFBAFuzXoH9B/ieXNeNXfAteEYPPA2AAGmj52GKAM87HHVpV0o4/V03NptzF
         8XuqMJKH46IXbKtTIEHlAXE5w5mWkRNeT+DcyEBBCh1vwPYRcOaEKzI7eXHixKE1tb/v
         b9EtlgNLjq275R6IWaAvUUvUhvVulrgC537Xa2NI+tqHGk3w+TPkYB0pPYpwlIvfYa72
         1ftqaIpfQehLRvsmHAvPPqrK9hsFK6TUVIDssG9EE+WZP5uoF6PgzA6rLXrwJoqOi5Aj
         PpPg==
X-Gm-Message-State: APjAAAUQ3MK/ZidFcPxq9TVCvQTKTfy61xYWAJHIJssHUhrXHE58qQRC
        QDCNResP1JMCyVZ2v/VUOqi18YJnCiFlrGJVET7CGEmR+FFz5mciHzEVsP4hSTiv0OxRS6RUy3t
        EpgpPe1bAqCgB
X-Received: by 2002:a1c:4b18:: with SMTP id y24mr20775351wma.71.1573491004964;
        Mon, 11 Nov 2019 08:50:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6RiMwSD37FdteASna5cqtLqVEzH/DXp9dI7zTSeL1HvDn3e3T6Ib9o6HtW4N4afn/DR31UQ==
X-Received: by 2002:a1c:4b18:: with SMTP id y24mr20775323wma.71.1573491004672;
        Mon, 11 Nov 2019 08:50:04 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id o10sm17725835wrq.92.2019.11.11.08.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 08:50:04 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: nVMX: Update vmcs01 TPR_THRESHOLD if L2 changed
 L1 TPR
To:     Liran Alon <liran.alon@oracle.com>
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-3-liran.alon@oracle.com>
 <a26a9a8c-df8d-c49a-3943-35424897b6b3@redhat.com>
 <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
 <72c26523-702a-df0c-5573-982da25cba19@redhat.com>
 <BD8FF780-C38E-493C-9BDE-FAFC1B3D25D6@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ad72854d-3b3f-ccdd-b213-2c3dbbca3b2c@redhat.com>
Date:   Mon, 11 Nov 2019 17:50:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BD8FF780-C38E-493C-9BDE-FAFC1B3D25D6@oracle.com>
Content-Language: en-US
X-MC-Unique: raEFigrtO4u3zEryxzc-Jg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 17:17, Liran Alon wrote:
> If I understand you correctly, you refer to the case where L1 first enter=
s L2 without TPR-Shadow,
> then L2 lowers L1 TPR directly (which load vmx->nested.l1_tpr_threshold w=
ith value), then an
> emualted exit happen from L2 to L1 which writes to vmcs01->tpr_threshold =
the value of
> vmx->nested.l1_tpr_threshold. Then L1 enters again L2 but this time with =
TPR-Shadow and
> prepare_vmcs02_early() doesn=E2=80=99t clear vmx->nested.l1_tpr_threshold=
 which will cause next
> exit from L2 to L1 to wrongly write the value of vmx->nested.l1_tpr_thres=
hold to vmcs01->tpr_threshold.
>=20
> So yes I think you are right. Good catch.
> We should move vmx->nested.l1_tpr_threshold =3D -1; outside of the if.
> Should I send v2 or will you change on apply?

I can do that too.

>> Also, what happens to_vmx(vcpu)->nested.l1_tpr_threshold if the guest is
>> migrated while L2 is running without TPR shadow?  Perhaps it would be
>> easier to just rerun update_cr8_intercept on nested_vmx_vmexit.
>>
> On restore of state during migration, kvm_apic_set_state() must be called=
 which
> will also request a KVM_REQ_EVENT which will make sure to call update_cr8=
_intercept().
> If vCPU is currently in guest-mode, this should update vmx->nested.l1_tpr=
_threshold.

Okay, that makes sense.  I was half-sure that update_cr8_intercept()
would be called, but I couldn't think of the exact path.

Paolo

