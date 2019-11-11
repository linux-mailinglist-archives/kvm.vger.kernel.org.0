Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB820F7861
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 17:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfKKQHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 11:07:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41239 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726845AbfKKQHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 11:07:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573488455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=e+s5Q6nkpItSisajOqHibP0amQ/WwUrCcTD18QwZU6s=;
        b=QoRB9eFikS47LhKb4ZsqdCn3yYKtp+i/PSbBkHC6PvPv5MUp11nZh9Wc9d9A2mjPixkFGP
        APYucCbM2HjoT4aQ0b2BAUh69SSRNFxcvfANpPQtoGANvc4JXPC2m2A8y7AujgGMe5td0s
        wNylZMOwqatZnY1WN5PikzOcpCDkhuo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-EHlOTHnzMTKANmu7RboCNw-1; Mon, 11 Nov 2019 11:07:34 -0500
Received: by mail-wm1-f70.google.com with SMTP id i23so7101880wmb.3
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 08:07:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1SXgNoAmO6Rxwo/WNXbqMCTSKdXViNaolXffIqz52QE=;
        b=anhK+6ZvGkiNPMNEV8VFwujdlc/oJ2YD65cyKfJ3uSaViiXYLOWDHK9tRgIGJ1lgex
         s616LW9JsrFBjKhbKMhBP7r/Zwo3FCvs6gL+j7rtFni0YcCFsak8HepCGTE7k7x4lMZP
         o/kPRNWyWNaPl76hPiyuyGfhRuEe9pi+A7X0qmHpttUEsBlcXxaaJzaIWFdBsqr/H9fV
         f4v9OHY+ks8bd+6EPqXNj1Wqt/seKXeg9tRHIU7iGBStA7bjmEe8Ik0smzFeMnAUpJVo
         aeqWBqnPR+LWgkdi0y6Tii7FWXOR+gxQCbbdzcp/YxieITDaYFAZ3kjhwqGb2o6QgFYK
         ykag==
X-Gm-Message-State: APjAAAVzUvipgL4gob5vBBQjWmS+lqDKZfVJK8o9rvPF3CAP5EtsmATY
        l6N0hiqetMaZjPdWngvGWKi5T9w/AbXJ9lOPA3FqbqG/76FAo5us7HNifRHfYak2CdMbKff+WUA
        NeX0+zEw5/9uS
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr20553987wmk.25.1573488452671;
        Mon, 11 Nov 2019 08:07:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqyTnAuPUU/9ARz+nhMtfgdhsu7hRriQqKqghHQGlRzqsr5kGOAb2hCfdTr3C/bJo+h/4yhNCw==
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr20553963wmk.25.1573488452382;
        Mon, 11 Nov 2019 08:07:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a0f7:472a:1e7:7ef? ([2001:b07:6468:f312:a0f7:472a:1e7:7ef])
        by smtp.gmail.com with ESMTPSA id 189sm20991891wmc.7.2019.11.11.08.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 08:07:31 -0800 (PST)
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <72c26523-702a-df0c-5573-982da25cba19@redhat.com>
Date:   Mon, 11 Nov 2019 17:07:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6CAEE592-02B0-4E25-B2D2-20E5B55A5D19@oracle.com>
Content-Language: en-US
X-MC-Unique: EHlOTHnzMTKANmu7RboCNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 16:24, Liran Alon wrote:
>> Can you explain why the write shouldn't be done to vmcs02 as well?
>
> Because when L1 don=E2=80=99t use TPR-Shadow, L0 configures vmcs02 withou=
t TPR-Shadow.
> Thus, writing to vmcs02->tpr_threshold doesn=E2=80=99t have any effect.
>=20
> If l1 do use TPR-Shadow, then VMX=E2=80=99s update_cr8_intercept() doesn=
=E2=80=99t write to vmcs at all,
> because it means L1 defines a vTPR for L2 and thus doesn=E2=80=99t provid=
e it direct access to L1 TPR.

But I'm still not sure about another aspect of the patch.  The write to
vmcs01 can be done even if TPR_SHADOW was set in vmcs12, because no one
takes care of clearing vmx->nested.l1_tpr_threshold.  Should
"vmx->nested.l1_tpr_threshold =3D -1;" be outside the if?

Also, what happens to_vmx(vcpu)->nested.l1_tpr_threshold if the guest is
migrated while L2 is running without TPR shadow?  Perhaps it would be
easier to just rerun update_cr8_intercept on nested_vmx_vmexit.

Paolo

