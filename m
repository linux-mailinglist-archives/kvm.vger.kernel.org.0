Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB0EFB8E
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 11:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbfKEKjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 05:39:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45588 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388335AbfKEKjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 05:39:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572950357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=2LvMAR7qEYceOIruV/PyzgaBYUpYPnN7jnQsKYSS5rg=;
        b=Kq6HDNXigJTFdU+urpmY9jQCFNNAluzBi0s+kfto+SiiTkSlQ/6eDgfPpgoo0MBonSh/ot
        6sB3gFKQVANwL/iqQcOZcfaDJz519hzx+P30WhNCrfFbOIL0ad0Nj+QxJkcy3gBTPfhN4+
        Nvn1gGr3Aih0HLVd6pmvbpppUMAzczk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-2NVL4rfcMl6ix6mZCyf25Q-1; Tue, 05 Nov 2019 05:39:14 -0500
Received: by mail-wr1-f70.google.com with SMTP id e3so9646952wrs.17
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 02:39:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQ7KNUBzf77wNn2thS7O/9SDCA29U2fDLBv0oypYUBs=;
        b=bvCkSlmdPFkt/xpl0f57/J+Gw5iDk6/NizIZ+aE6AhTOly4pxjuYCW7JCjiYjL5I/N
         n04jncDwDz3e06lALHfbldRQd8+emg82TfkylFkYXOqDRDmVPBIkwnVpcyT65FchjfrH
         fBrJfeAilrAxLx7PQotoBCytqShNTMD9Q5TB5iEYMwnkQ1zlKJ59EDYGvLj1qfNH2VXv
         QzFCdZB8o5ERukOCe/2D+uZ3bcby3ambNi3uZtDgTHfvEFrehS+MxMRhE/i1pb+AkFGQ
         XEoeWQFzpSMce0IR6mUAHQ1uEwSbbSFbF8dlhWXyifF+zL8nzajFC70prnkvIX4cDJRa
         uKfQ==
X-Gm-Message-State: APjAAAWiS8KKtdG2jUF0Nne38HS787bIli3jRvZyfr3qLoeTqTDYXrOz
        JmTmoufEAj0fyplRNPD//AlIoXyytQeClC6WylaE5KwViAqrW2k8yZLI8LNnoxq2ksLPJY1kyae
        Oq25Nx1vuGOD4
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr3776068wme.92.1572950352541;
        Tue, 05 Nov 2019 02:39:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqySoQAJvIlF1vGOb45cphI3Izmbvr5QW4TLhFheXcM+rcB+CvVBm3cdOFdSMsff8CVY53J9iQ==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr3776043wme.92.1572950352278;
        Tue, 05 Nov 2019 02:39:12 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j3sm12570845wrs.70.2019.11.05.02.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 02:39:11 -0800 (PST)
Subject: Re: [PATCH] kvm: cpuid: Expose leaves 0x80000005 and 0x80000006 to
 the guest
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <20191022213349.54734-1-jmattson@google.com>
 <CALMp9eR7temnM2XssLbRF0Op+=t0f-vwY-Pn4XgZ4uEaTW57Yw@mail.gmail.com>
 <6e847c96-46f7-bd60-1b0f-2b6cdb5d4bca@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2bd3a7c2-bcc6-9479-151c-f3067366cd7c@redhat.com>
Date:   Tue, 5 Nov 2019 11:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6e847c96-46f7-bd60-1b0f-2b6cdb5d4bca@oracle.com>
Content-Language: en-US
X-MC-Unique: 2NVL4rfcMl6ix6mZCyf25Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 03:02, Krish Sadhukhan wrote:
>>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x80000005:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x80000006:
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 break;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case 0x80000007: /* Ad=
vanced power management */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* invariant TSC is CPUID.80000007H:EDX[8] */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 entry->edx &=3D (1 << 8);
>>> --=20
>>> 2.23.0.866.gb869b98d4c-goog
>>>
>> Ping.
>=20
> Just curious about where we are actually setting the information for
> these two leaves. I don't see it either in __do_cpuid_func() or in
> kvm_x86_ops->set_supported_cpuid().

do_cpuid_1_ent simply passes down the host information.

Patch queued, thanks.

Paolo

