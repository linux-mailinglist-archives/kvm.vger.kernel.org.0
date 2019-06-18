Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF994A390
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfFROMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 10:12:10 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:36613 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFROMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 10:12:10 -0400
Received: by mail-wr1-f46.google.com with SMTP id n4so6085615wrs.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 07:12:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rrXMXpzbLHYWoPmWC5n+pSG3XnFX73+2zomHtUyoxJA=;
        b=PT+vKNnOOUS/z+n9AtFLug4Iv9cp6sjs2KqrhHDVT8yBdEX4mgUhZGVEpFlruVGZCW
         8GsymY1y+OvpWJV8WlZWv1afAeSnzGs+E8b/0CcB9GE3Vx6/UVAV0LhAjAprBmK+EX9b
         QjMnvoIA+m/1p1QEJstIpgJEd0p6TPxe/e5hVg3bMxa/f3rnRaI5BqvJCCo6damrhqky
         tcCsWLZzkq1AWbznaJ4C5SqcceOSTDNUqwrppRgnaBCPT1aTPjNY+Ty2oAoAzvCmqL6w
         yaMSruaLamXcXYUpHYXBRyjQLIVt/MPJraGQ0lJs6vPGWfumxCrYPleKJ6H5LQokDXMj
         edcQ==
X-Gm-Message-State: APjAAAUWBmlp4aE4M+9UKxbQthXNZpBcmOwu2F2GcZdDHueLNgJD3uF/
        b3A+UJPK68Z0tdGEXX5L6MbONw==
X-Google-Smtp-Source: APXvYqxQOzEEANW8cL2Z6GoHNiY3bA5AwP2/C3NgjiOh85rwu/opRi8JatBiByMGYtF17TQM9MNt1Q==
X-Received: by 2002:adf:ce03:: with SMTP id p3mr57336746wrn.94.1560867128686;
        Tue, 18 Jun 2019 07:12:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51c0:d03f:68e:1f6d? ([2001:b07:6468:f312:51c0:d03f:68e:1f6d])
        by smtp.gmail.com with ESMTPSA id t140sm3663547wmt.0.2019.06.18.07.12.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:12:07 -0700 (PDT)
Subject: Re: KVM: x86: Fix emulation of sysenter
To:     Saar Amar <Saar.Amar@microsoft.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <AM0PR83MB0307F44E915135F79E291058F1EA0@AM0PR83MB0307.EURPRD83.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53b1ac7e-0170-b966-d3f0-298e291e9bdd@redhat.com>
Date:   Tue, 18 Jun 2019 16:12:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <AM0PR83MB0307F44E915135F79E291058F1EA0@AM0PR83MB0307.EURPRD83.prod.outlook.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/19 15:19, Saar Amar wrote:
> I found a bug in sysenter emulation. Patch attached both in plaintext
> and as patch file.

Do you have a testcase for this?  RF is cleared for all instructions here:

        if (ctxt->rep_prefix && (ctxt->d & String))
                ctxt->eflags |= X86_EFLAGS_RF;
        else
                ctxt->eflags &= ~X86_EFLAGS_RF;


just before em_sysenter is called.

Paolo
