Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28B45D0D29
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 12:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730728AbfJIKus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 06:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727657AbfJIKus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 06:50:48 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3398581DE1
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 10:50:48 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id v17so920547wru.12
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 03:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bmn/r0BsJ/ckLkCEhbCCOJ9mUA04B3GjpaUyic1itQY=;
        b=fKfl49cc1TxCoyZmW0hPW3p2IWxh6Ll//DFzP9p/roVYSa/49ahhD3+q9NPSN0x81O
         L1WuaJBUp32LQsNbcJti5zYW4CM7EeG59fw0zzThokyhbHWQcUYvucq8WdpwAaRu0Or9
         sikSHzrDvFOMp+t9n17jewhNug5TzDeVD2iJwZOvEUMfnUc1jTNrtKfx9hVwmN3eA3+8
         eFzHCIdd7MisJEsjcZgZ0pin4Ct0kPMhgm7zUwgCx24YvZ9l8Hlk8BXDfLChnyuVDs24
         KvTUhAtOaz7VUVlN2CBhhkF34bQZFPhNlnS81bUQaqvQS9X82M3TzUztup5sasJXd9J7
         +ZYQ==
X-Gm-Message-State: APjAAAXziaZsxZv8dAPWnQnLk1oljaE4BEjab8Xd6fDzqHqrkaEB1bX6
        OshlGf4yFuC5V52u7zY6Tn+ZgnL60GXzoNhT6HHMGxp4bEfGuYXLT92LlNuvVeZlehI6cV8PX3x
        788iv/3rxTKZh
X-Received: by 2002:a1c:990a:: with SMTP id b10mr2059255wme.39.1570618246852;
        Wed, 09 Oct 2019 03:50:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwhBZEvSW0EUo/Gi5mU/wgwGG9A2c5aEjG6Esfy9ahvDY3vtdaKuBgF6plJ2JQLOMY1Q38/Fg==
X-Received: by 2002:a1c:990a:: with SMTP id b10mr2059238wme.39.1570618246602;
        Wed, 09 Oct 2019 03:50:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:f4b0:55d4:57da:3527? ([2001:b07:6468:f312:f4b0:55d4:57da:3527])
        by smtp.gmail.com with ESMTPSA id n1sm2469406wrg.67.2019.10.09.03.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:50:46 -0700 (PDT)
Subject: Re: [PATCH v2 5/8] KVM: x86: Add WARNs to detect out-of-bounds
 register indices
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <9e4570a4-1da1-1109-32d3-1fba25de1963@redhat.com>
Date:   Wed, 9 Oct 2019 12:50:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927214523.3376-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 23:45, Sean Christopherson wrote:
> Open code the RIP and RSP accessors so as to avoid pointless overhead of
> WARN_ON_ONCE().

Is there actually an overhead here?  It is effectively WARN_ON_ONCE(0)
which should be compiled out just fine.

Paolo
