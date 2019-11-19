Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FA10282C
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 16:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfKSPeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 10:34:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56693 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbfKSPeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 10:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574177652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=vsdYTJdmpDHbVtC2zk2nGSmOi1xZDU6iXkwC9cjzFi4=;
        b=iHhlZcYgYuprg8fyPh+Pu9U413S25yqMD/n94BGmrRH9qPEGRzu6GihF7T6EH35UKX0AG0
        jGS9SDpUPddFORMFmY6wSIh/2AP4gRnZub1jVPKUMR70l2rwkI47TKs5FTy5MnQvCRgFwb
        s9Rlp/dJOITdcgUajD7Q3CdbWJ0wDx8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-pX6x-rdmNwu2grFmazfsoQ-1; Tue, 19 Nov 2019 10:34:08 -0500
Received: by mail-wr1-f71.google.com with SMTP id m17so18377361wrb.20
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2019 07:34:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vsdYTJdmpDHbVtC2zk2nGSmOi1xZDU6iXkwC9cjzFi4=;
        b=F8NbfJriVKiaBDyHLSomFu4Tv+Dj4ss90S8mq40wRWPiCYk2b2j4iOfD9JD4m1oXmC
         30qjEItCX9RRJhUKYOwdlIfKmgAhZR1sopxS1Jacjenzg+lsuYG33l5XcAFUKO/krX5g
         n9Y6RW/SmGNpl3HMNX0niacfm01GI1W8C/HrqrRYg7bC01t2acMxALRqNkXbN7eF2dMG
         +06kFKrskPww9hXhQ86UF+wVRLAgzHxHZMvUxV52+sXGFAd3EcZL4xxSDfX1CL6r0zDF
         YsBUSoJkDxYjcLUOnOegJPIF103hgZKy3RZa3nQkZuUBeUjs7Cdm6zHIvvvRlo/9TNSP
         0Fcw==
X-Gm-Message-State: APjAAAXYAcXandtlIz2KGCN4dgNMPEOjYNX/mUnp8Mt+k0tB6LI0jDql
        a8FHvYiMq5yKFtZl9tiaOOJHLBryrfj5VWLRwJIp/UhhpDc7WIRNBF/k9j8k6AWS93jzCy8UBu4
        9Dv8XlaG/RCEp
X-Received: by 2002:a5d:55c5:: with SMTP id i5mr40433387wrw.385.1574177647546;
        Tue, 19 Nov 2019 07:34:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqzVjuaWaSzK+Xt0uthz4GESPeUTp9jQ83f6FN4gk/aBwTbkqxZ64EyharajI6xyCW8Fc3EQvA==
X-Received: by 2002:a5d:55c5:: with SMTP id i5mr40433346wrw.385.1574177647261;
        Tue, 19 Nov 2019 07:34:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id w18sm27314242wrl.2.2019.11.19.07.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 07:34:06 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: add CR4_LA57 bit to nested CR4_FIXED1
To:     Liran Alon <liran.alon@oracle.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191119083359.15319-1-chenyi.qiang@intel.com>
 <348B5C47-7AA0-4DAC-91A7-8FB0D0205EF6@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3a5cc588-50b7-8ce1-bb66-19b45c50dee6@redhat.com>
Date:   Tue, 19 Nov 2019 16:34:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <348B5C47-7AA0-4DAC-91A7-8FB0D0205EF6@oracle.com>
Content-Language: en-US
X-MC-Unique: pX6x-rdmNwu2grFmazfsoQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 12:09, Liran Alon wrote:
> Reviewed-by: Liran Alon <liran.alon@oracle.com>

Queued, thanks.

Paolo

