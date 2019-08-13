Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6818B3D6
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 11:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfHMJQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 05:16:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53967 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbfHMJQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 05:16:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id 10so797566wmp.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 02:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rJyEXL/9pmUa8F8Nq9N9p+VTELu7g73JrfbMzEYtsqw=;
        b=sPWuWuuXiz+q0/CuTqmL+0Isz/DeXE5xwrdGVJFOBcyEw4x8/5qodx+KyD7kTWCAbK
         h3Ox8Y4DvsYP+WFw7cZIGYBCe+z/pciy1gWLUdezWOYCjpOW36pEPvbcMwjDz/6FpK/m
         Mwa0gub/xZphhIGU6EzKOrKt4KpkyeqdZAhs1gEbmTX1NsPPGHzhsKWg6AUaMHuD12iz
         JgUNYUbeUPig8zBCOwkJsPLIKUbdswXP5+mry3GtrpPEv61krMmgjj21luFKLBAinmJ5
         Ud+Yc69DQbNbKYTQEqHdWTh1Q1ms5jurQpNRfMbGmvIc4wPgzh+UVLEMBsrOlaBANuAC
         fOUA==
X-Gm-Message-State: APjAAAU1Dh0LRnKiGb+4ut+dSF5jALwAya7x1IuIVgL2jIV9/8iv94IK
        2cY58bf7NDp72A7yl+5CRdMCIA==
X-Google-Smtp-Source: APXvYqwm309us5aZi/frD8eACHl5aijviV3HAVkqCeaBNsVD1mdnoZLmf1PImPsBNT+r6Tg0wB86fA==
X-Received: by 2002:a7b:cf0b:: with SMTP id l11mr2056631wmg.143.1565687764702;
        Tue, 13 Aug 2019 02:16:04 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c15sm59116320wrb.80.2019.08.13.02.16.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 02:16:04 -0700 (PDT)
Subject: Re: [RFC PATCH v6 07/92] kvm: introspection: honor the reply option
 when handling the KVMI_GET_VERSION command
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-8-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a5cdbbd4-6f25-a0a5-054e-5810b5828a48@redhat.com>
Date:   Tue, 13 Aug 2019 11:16:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-8-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 17:59, Adalbert Lazăr wrote:
> Obviously, the KVMI_GET_VERSION command must not be used when the command
> reply is disabled by a previous KVMI_CONTROL_CMD_RESPONSE command.
> 
> This commit changes the code path in order to check the reply option
> (enabled/disabled) before trying to reply to this command. If the command
> reply is disabled it will return an error to the caller. In the end, the
> receiving worker will finish and the introspection socket will be closed.
> 
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
> ---
>  virt/kvm/kvmi_msg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
> index ea5c7e23669a..2237a6ed25f6 100644
> --- a/virt/kvm/kvmi_msg.c
> +++ b/virt/kvm/kvmi_msg.c
> @@ -169,7 +169,7 @@ static int handle_get_version(struct kvmi *ikvm,
>  	memset(&rpl, 0, sizeof(rpl));
>  	rpl.version = KVMI_VERSION;
>  
> -	return kvmi_msg_vm_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
> +	return kvmi_msg_vm_maybe_reply(ikvm, msg, 0, &rpl, sizeof(rpl));
>  }
>  
>  static bool is_command_allowed(struct kvmi *ikvm, int id)
> 

Go ahead and squash this in the previous patch.

Paolo
