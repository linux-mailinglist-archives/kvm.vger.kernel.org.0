Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA1220443D
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 01:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgFVXE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 19:04:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51881 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731367AbgFVXE1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 19:04:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592867066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRzCWX3ReFeVc/uIdEctANg6zEVQMutBkN5Zs6/zBBA=;
        b=JE7fMMBclqJavxmSXwDiG5mu5xajiUcEdLFEqyq+718nLBoHkq1VLM5npeQHpIPs9eDfzc
        SCI+eKS5VC7D3Kp53yRVEoCEdM5lEpiPAJO1dZ2dwB1eya8KTF4JX3bWWl+TI9C7+RImxf
        VdvZN1wzEWolAxTdrVf7bIOzh0Yvzrw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-Wlg1U57wMBSB11c7qLj7NA-1; Mon, 22 Jun 2020 19:04:25 -0400
X-MC-Unique: Wlg1U57wMBSB11c7qLj7NA-1
Received: by mail-wr1-f69.google.com with SMTP id a18so534851wrm.14
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 16:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xRzCWX3ReFeVc/uIdEctANg6zEVQMutBkN5Zs6/zBBA=;
        b=fa2KJDlM6NHLecf3XEB5QSL+G5Wq08hpkjjbT0vKFfEvJ5tsfKjp12zMaWHPbPbqA+
         sPEkGVD+0MQ6i4YkdJ9Jy0dk6X7dz1snUZDHFnB102i8gX8l8X07EoeLy5tg5zDiWoN2
         28uuaFGHRFrAW519Og2Wtzw4xW1kQ+A7lowyyPuLE5iSVhYjOfkS0yewgxYnibkT+XGx
         /H7bQ730twxsrUjDrKJVPRiaxxf8HORVIglX+sZvvdbfgxhAAqJwAUnI2WVjmh/zHNSw
         hJKvEARsP6XKfrx7+sCCmhmUm0fDDfTGXQEyhjvJx+bJ5CJAiPVG5S7QGBSR/UcVprTb
         5T7A==
X-Gm-Message-State: AOAM531gUG7kthkbi1xMQXczQ8bs1LbK/1AHM7oa8QIs1XfmFTsNjgVj
        AvlH2jJGYKLfZm8kOmyubFobmC8Xf+jXu8tlrxT0iDCvbdj09+TRItdpvUcaCiKLi36K9BHYiPc
        NrarNwNWysN3p
X-Received: by 2002:adf:de12:: with SMTP id b18mr13456198wrm.390.1592867063781;
        Mon, 22 Jun 2020 16:04:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCMm76vknqfhl5TfPdRFe6d9kiyEXsSRCmb/qlBxD84BMRtMxK4i/hWNfm4fQnzbqWzWzSGw==
X-Received: by 2002:adf:de12:: with SMTP id b18mr13456180wrm.390.1592867063556;
        Mon, 22 Jun 2020 16:04:23 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id 1sm1202692wmf.0.2020.06.22.16.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 16:04:23 -0700 (PDT)
Subject: Re: [PATCH v2] target/arm: Check supported KVM features globally (not
 per vCPU)
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
        Andrew Jones <drjones@redhat.com>,
        Haibo Xu <haibo.xu@linaro.org>
References: <20200619095542.2095-1-philmd@redhat.com>
 <20200619120202.GH2690@work-vm>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3ceeab9-aeab-175c-f778-22574f49f684@redhat.com>
Date:   Tue, 23 Jun 2020 01:04:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619120202.GH2690@work-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 14:02, Dr. David Alan Gilbert wrote:
>> Paolo, does this break migration of encrypted memory assumptions?
>>
>> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
>> Supersedes: <20200617130800.26355-1-philmd@redhat.com>
> I'm not seeing the relevance to migration.

I told Philippe that there could be a possibility in the future of
having more than one KVMState to support SEV live migration, so removing
all KVMState* arguments is not a good idea.  But for kvm_check_extension
calls it should be safe, as those should be the same for all VMs.

Paolo

