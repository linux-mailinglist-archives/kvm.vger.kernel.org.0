Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257D1617F56
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKCOWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiKCOWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B63B23
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667485276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ce30PlUaAvWtlyscTUqBTgqw9q6bbQE1OIBsSDReTF0=;
        b=K4rcMasdTu0aa8s1R7hkDUEqp17xtkY+iJPjRmpk3/eNzRf7nZrMI3G/JWEf3cM3VbEns9
        nkMW88iwbnp87/aD2NFFiVVwd/mU+McI7pWpSPqVxWciJQHeJwxHHks9HTLWcURwpma4Ww
        4z/WgWv9BKBRD56+iLM5YGehxZqqrkQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-KOBODGo9NpG7jQHRC0Qoow-1; Thu, 03 Nov 2022 10:21:15 -0400
X-MC-Unique: KOBODGo9NpG7jQHRC0Qoow-1
Received: by mail-ej1-f72.google.com with SMTP id he6-20020a1709073d8600b0078e20190301so1352094ejc.22
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 07:21:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce30PlUaAvWtlyscTUqBTgqw9q6bbQE1OIBsSDReTF0=;
        b=O8FwfYLL5wwcM1fchY8KRG7JZfccYb2abtJz4nZDXsHcRW2Cm9lB8x2RDRuQxNCcDq
         fwmGRv/3rTodOxJnTVepj54s+t7KGuV9tMssGamEcA/lWWvAv7aAEMkTx6jiVn2USPz9
         fVdlzPeujVF6EuEZMvu/2UONHcieevOFl2edMebmwIbUXMw+ZlFUuBLFf6cw6Y/XtHDo
         U0V7X+Lt3EmbwvJnFk/Pr4PQBFHLtjU8uIf2Rb9FZMjkER2DKE5xbdc0wbOA2OV1Gp6o
         BJWstP9L0xSrnWFhIW8V99dIAWi1XelIFbVfgdCCi54AF1s+07R7ucM/te7jiYkW/oxA
         hYtQ==
X-Gm-Message-State: ACrzQf06JbaIIsuplncn7hbWRb76uZTXlu57Jfu6P2hv7JRWE197Erh5
        EvuHHbk0WVwBEj2vpZbR236aleAaZ79e/yNuSEAp6GW8j6mbARN6Dw6zwMKCO44UfFd6iNGWV+J
        a3ojXeNjeV02j
X-Received: by 2002:a17:907:6d22:b0:7ad:5cd3:d33a with SMTP id sa34-20020a1709076d2200b007ad5cd3d33amr28375100ejc.622.1667485273934;
        Thu, 03 Nov 2022 07:21:13 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6yjWLlJjdX00UUzGGT/4RdepXpECARyC2atUebpbZwkDSNOfLx7vcGW0i8mbz3yiKU7J8iBg==
X-Received: by 2002:a17:907:6d22:b0:7ad:5cd3:d33a with SMTP id sa34-20020a1709076d2200b007ad5cd3d33amr28375086ejc.622.1667485273704;
        Thu, 03 Nov 2022 07:21:13 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id 2-20020a170906200200b007acbac07f07sm564018ejo.51.2022.11.03.07.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:21:13 -0700 (PDT)
Message-ID: <f5315936-fbdf-c7b1-e7a9-f494001eebfd@redhat.com>
Date:   Thu, 3 Nov 2022 15:21:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Content-Language: en-US
To:     Matthias Gerstner <matthias.gerstner@suse.de>, kvm@vger.kernel.org
References: <20221103135927.13656-1-matthias.gerstner@suse.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] tools/kvm_stat: fix attack vector with user controlled
 FUSE mounts
In-Reply-To: <20221103135927.13656-1-matthias.gerstner@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 14:59, Matthias Gerstner wrote:
> The fix is simply to use the file system type field instead. Whitespace
> in the mount path is escaped in /proc/mounts thus no further safety
> measures in the parsing should be necessary to make this correct.

Can you please send a patch to replace seq_printf with seq_escape in 
afs_show_devname though?  I couldn't find anything that prevents 
cell->name and volume->name from containing a space, so better safe than 
sorry.

Paolo

