Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07BE722DDB
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbjFERrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjFERrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:47:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A02F1
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 10:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685987222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uRs0E0ZsQo9CBSAvjs75Bate5XC6YOXzDnFeKEEASU=;
        b=D5JaJ/jjehk8bDQqYQDWtTxMF4YyCvk5CgsdEC1aefRcSDUFlT4gud+z18b5ylVUrDW7hA
        iQxRcGAQeHfNu2gICDz+6eOhfi+YbW2C8mp4irWp/iiKzaPxevttMcMdHaukkb+fDnpEy4
        23HrBlgC4PkHEZgY+5HXT6+xdw08uzE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-x9vyMpqCNBK3gAIDVcrcug-1; Mon, 05 Jun 2023 13:47:01 -0400
X-MC-Unique: x9vyMpqCNBK3gAIDVcrcug-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30ae56a42cfso2691632f8f.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 10:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685987220; x=1688579220;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+uRs0E0ZsQo9CBSAvjs75Bate5XC6YOXzDnFeKEEASU=;
        b=kgc9/PICk5cy6vFIDmeSmXuEC468P1pOpwXv6aZrBw7Qb0oT2buDNPUQkR3bcQsu43
         jXUTHkL/kkmW0wGAmo/rmFLwtllYzlNLEZjnUo8oSJaar3LBI0VTbVNZMgXNELjTArgA
         hd6wdxsyntEoBMU2O5u8eOuiwqzTHrD5aTG2KrICRlI4pUGjzSMDP9c33hFs0WB70bHS
         iGGRKB2Z5oAY7kGdFJA/++OLY7TdypqPCVbb0hWnNpa+KVtzGFl5qyk2/0+J5lW3eLtD
         AeD9UcyVip1qCSDyp/53OGhopxCDMzk9xnAconHBQmpq93nYN1BzKSHDHKHGG16Qq837
         qKTg==
X-Gm-Message-State: AC+VfDztZJ8yXBqCrb3xmWYzIGDHl2XVbUuOJgICirvYDAijg6FnIg0o
        LnAj+yv/InA2fgQcxzxX/+NmTWcUF+rz6yJs8Rb4EQWW3aWzB2Eld8CD/Dd8Z20kGvNvJ3WsWPi
        3arxRANK4hYux
X-Received: by 2002:adf:ce89:0:b0:2f9:4fe9:74bb with SMTP id r9-20020adfce89000000b002f94fe974bbmr5734006wrn.40.1685987220036;
        Mon, 05 Jun 2023 10:47:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ68oEP7AT12T23v/QzZD9CTbrZYbJ6uz4hfM0/PmGVU73mfT0itIWdf6a88W0ApVEhjxV8M2w==
X-Received: by 2002:adf:ce89:0:b0:2f9:4fe9:74bb with SMTP id r9-20020adfce89000000b002f94fe974bbmr5733996wrn.40.1685987219732;
        Mon, 05 Jun 2023 10:46:59 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 8-20020a05600c230800b003f6cf9afc25sm15229244wmo.40.2023.06.05.10.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 10:46:59 -0700 (PDT)
Message-ID: <19c775ad-9573-b4d4-886d-c631b468856f@redhat.com>
Date:   Mon, 5 Jun 2023 19:46:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 03/59] arm64: Add missing VA CMO encodings
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <20230515173103.1017669-4-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20230515173103.1017669-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/23 19:30, Marc Zyngier wrote:
> Add the missing VA-based CMOs encodings.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/include/asm/sysreg.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 108663aebccb..071cc8545fbe 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -124,6 +124,32 @@
>  #define SYS_DC_CIGSW			sys_insn(1, 0, 7, 14, 4)
>  #define SYS_DC_CIGDSW			sys_insn(1, 0, 7, 14, 6)
>  
> +#define SYS_IC_IALLUIS			sys_insn(1, 0, 7, 1, 0)
> +#define SYS_IC_IALLU			sys_insn(1, 0, 7, 5, 0)
> +#define SYS_IC_IVAU			sys_insn(1, 3, 7, 5, 1)
> +
> +#define SYS_DC_IVAC			sys_insn(1, 0, 7, 6, 1)
> +#define SYS_DC_IGVAC			sys_insn(1, 0, 7, 6, 3)
> +#define SYS_DC_IGDVAC			sys_insn(1, 0, 7, 6, 5)
> +
> +#define SYS_DC_CVAC			sys_insn(1, 3, 7, 10, 1)
> +#define SYS_DC_CGVAC			sys_insn(1, 3, 7, 10, 3)
> +#define SYS_DC_CGDVAC			sys_insn(1, 3, 7, 10, 5)
> +
> +#define SYS_DC_CVAU			sys_insn(1, 3, 7, 11, 1)
> +
> +#define SYS_DC_CVAP			sys_insn(1, 3, 7, 12, 1)
> +#define SYS_DC_CGVAP			sys_insn(1, 3, 7, 12, 3)
> +#define SYS_DC_CGDVAP			sys_insn(1, 3, 7, 12, 5)
> +
> +#define SYS_DC_CVADP			sys_insn(1, 3, 7, 13, 1)
> +#define SYS_DC_CGVADP			sys_insn(1, 3, 7, 13, 3)
> +#define SYS_DC_CGDVADP			sys_insn(1, 3, 7, 13, 5)
> +
> +#define SYS_DC_CIVAC			sys_insn(1, 3, 7, 14, 1)
> +#define SYS_DC_CIGVAC			sys_insn(1, 3, 7, 14, 3)
> +#define SYS_DC_CIGDVAC			sys_insn(1, 3, 7, 14, 5)
> +
>  /*
>   * Automatically generated definitions for system registers, the
>   * manual encodings below are in the process of being converted to

