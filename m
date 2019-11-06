Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD13F129B
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 10:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbfKFJpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 04:45:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfKFJpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 04:45:01 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8AFBD859FE
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 09:45:00 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id l3so5340672wrx.21
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 01:45:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q2jUnPlZpq07oDm9GijOu7mC0nL0SjcNzrjjj8E2oWY=;
        b=c3siSCV9td0AeDYIvneyHh0dpEnZ/HvG9Sj7Wf8BCX3rD3AK8rthhCzxfAyDtTCTzd
         Cvg9Toktc3dfpLAqmuQ4fdr/XM6p3NcimB051tLoHGdhIACnpm8eVBboceaCbfJ8jl8N
         yhftTgMD5ozUhEPQveXTCDMSPLXd9zhVYsLAe36uIZkBmILuxZKpTng3uOBHzXAD5gHA
         HZmXBaP3f4J7ts8mmbv28iLkujOSAEMxRc9tUxjzA2ooQDnq/kjbUKtGk338ozHhS0dP
         CqOL1Fc42yRawfRQ/2sPuo71s80XmRWUW4yuMMxcFZYBPV1jT5c56vXhSWXqr6tT+P2t
         Lujg==
X-Gm-Message-State: APjAAAUhMjnVMKyAL1MlnkKHfA59iEt0hJIXjDaHEv+Xz3R3kT3q60oR
        iQ/yY+SbcCFIrNOO0/4SoLrtdAtYlkz+kA5OFkcsNUdtC/9GxJ7OXVhVXQCGb16HwCnpOEy/R8k
        J1rCpMfjTOYlC
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1586036wmo.147.1573033499179;
        Wed, 06 Nov 2019 01:44:59 -0800 (PST)
X-Google-Smtp-Source: APXvYqzy6ZB2McWXQnxB1WXTjJovdTVeWBiliCnOZxLunZefkUZmU+i0YssuwnYkfHXlbbAwIjGLmg==
X-Received: by 2002:a1c:28d4:: with SMTP id o203mr1586020wmo.147.1573033498912;
        Wed, 06 Nov 2019 01:44:58 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id s21sm33339142wrb.31.2019.11.06.01.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 01:44:58 -0800 (PST)
Subject: Re: [PATCH] kvm: Fix NULL dereference doing kvm_create_vm()
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jim Mattson <jmattson@google.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
References: <20191106082636.GB31923@mwanda>
 <8f7e33e9-9ae0-4f56-3bb6-b9f3db807d38@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7eddf725-e034-d65d-3fb1-2babcfaa812d@redhat.com>
Date:   Wed, 6 Nov 2019 10:44:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8f7e33e9-9ae0-4f56-3bb6-b9f3db807d38@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 09:30, Christian Borntraeger wrote:
> The same patch was already sent by Wanpeng Li.
> 
> See 
> https://lore.kernel.org/lkml/1572848879-21011-1-git-send-email-wanpengli@tencent.com/

I'm also going to send a somewhat different version today (hopefully).
Stay tuned...

Paolo
