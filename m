Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DEC7B69C6
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 15:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbjJCNEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 09:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjJCNEH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 09:04:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8FD893
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 06:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696338198;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GFwg56FjUnk/RYyxX0j6V0Iiz4DYd4P83sGmmUcaE8=;
        b=KxXYstQj2QNguSZW2zsV5Z9VYPBh9a59t21Z+UjiLVTCRyctEF3MSJI3PqdGPJhshDTdLc
        L99AeKipRacMXHSt1fs7LtVaQRVkoOVOpk0iUHmq47FKTYUldyibL+GGmf7Kmxr7fNGqgn
        LCCQOJcBLgfs5TKy7utlPNqIX+zl6M4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582-y20zWZnVN0eN0lDzVyyJHQ-1; Tue, 03 Oct 2023 09:03:01 -0400
X-MC-Unique: y20zWZnVN0eN0lDzVyyJHQ-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6557c921deeso9632456d6.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 06:03:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696338181; x=1696942981;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GFwg56FjUnk/RYyxX0j6V0Iiz4DYd4P83sGmmUcaE8=;
        b=ryFzJxQHGAT5SgGNrI8wWcLRxA3WIkjIphPxmgcHvE7EjcvySqlH2lpJvKj1G9TVPv
         rkv82MraiM1Mk5Luu8GWsEag5xf6qiqdTTVyrLGMaL2xhNrn25BnWCOprTgjW7brIU4z
         G2wKnb+CzOMQXso3O9vZEFKGfpciPy61zyDXfVeP4ODTc0jv9HsB/B0YI9i0FkYB07S9
         aWTnlqT5nh4jEu/eChL8TwwQ/1Qu7YbTc+oWFSO6j6m1NOgTwcrcXEPqoBXS2fkzR56H
         nKkxDEGv3JNGXkKMwDMxJ52mW4oYi40SryqNJ/On+WHUKGrTH8G8UcYr5DWnrBiQ7wEU
         0Uyg==
X-Gm-Message-State: AOJu0YzLbCILd6lQoJSpL33islc6TJLpthDo5Dff5xkmPSkizVAcWiJJ
        3sCjUP97hqbSHkP9anBYz1yMb3LECrAU1COu6sMjEsMU6h+DC0+gLqbP9KCwyM0oOL5zQw+wV0U
        q68xvkQe2QN7x
X-Received: by 2002:a0c:e184:0:b0:64f:3bec:9b29 with SMTP id p4-20020a0ce184000000b0064f3bec9b29mr16313142qvl.39.1696338181298;
        Tue, 03 Oct 2023 06:03:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFu2JXglfNoNOa1zYOGFmLH18oaA0qRkmgTq9KV7s1VRSKyL03flSA7O6FwDPBplykwo50Vg==
X-Received: by 2002:a0c:e184:0:b0:64f:3bec:9b29 with SMTP id p4-20020a0ce184000000b0064f3bec9b29mr16313116qvl.39.1696338180979;
        Tue, 03 Oct 2023 06:03:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s2-20020a0ce302000000b0064723b94a23sm453235qvl.27.2023.10.03.06.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 06:03:00 -0700 (PDT)
Message-ID: <ef81a814-2733-8c1a-bfb0-bb1187881c94@redhat.com>
Date:   Tue, 3 Oct 2023 15:02:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH] arm: pmu: Fix overflow test condition
Content-Language: en-US
To:     Matthias Rosenfelder <matthias.rosenfelder@nio.io>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Andrew Jones <andrew.jones@linux.dev>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>
References: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <FRYP281MB31463EC1486883DDA477393DF2C0A@FRYP281MB3146.DEUP281.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthias,

On 9/29/23 23:19, Matthias Rosenfelder wrote:
> Hello,
>
> I think one of the test conditions for the KVM PMU unit test "basic_event_count" is not strong enough. It only checks whether an overflow occurred for counter #0, but it should also check that none happened for the other counter(s):
>
> report(read_sysreg(pmovsclr_el0) & 0x1,
>       "check overflow happened on #0 only");
>
> This should be "==" instead of "&".

Your change indeed makes sense to match the comment. Please resubmit
following Drew's hint and feel free to add my

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
>
> Note that this test uses one more counter (#1), which must not overflow. This should also be checked, even though this would be visible through the "report_info()" a few lines above. But the latter does not mark the test failing - it is purely informational, so any test automation will not notice.
>
>
> I apologize in advance if my email program at work messes up any formatting. Please let me know and I will try to reconfigure and resend if necessary. Thank you.
>
> Best Regards,
>
> Matthias
> [Banner]<http://www.nio.io>
> This email and any files transmitted with it are confidential and intended solely for the use of the individual or entity to whom they are addressed. You may NOT use, disclose, copy or disseminate this information. If you have received this email in error, please notify the sender and destroy all copies of the original message and all attachments. Please note that any views or opinions presented in this email are solely those of the author and do not necessarily represent those of the company. Finally, the recipient should check this email and any attachments for the presence of viruses. The company accepts no liability for any damage caused by any virus transmitted by this email.

