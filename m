Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2AD6EB5CF
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 01:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjDUXtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 19:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbjDUXtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 19:49:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D623212F
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682120929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ty3XjvTMJPmSzqLtzAvHrgacbo7grKCh8Eml4uSwPk=;
        b=isI6vp3HZxozF80KIDghKeiVEM6tzM3jsQ32RPUXkSxXDzjtcwclgsp+JB+YWIJvznMadi
        1jeklsMz+OGooLAkQ7tO7e4cPkZ2gXJC/NhCHKCdR12kgcPQdZEhBBb2HbJcznrHSSle1b
        8ezXh3p1JJXe2z5JstlfWjJ5r6AU4ME=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-ZgalExy5NyWxRbHjCf5mdQ-1; Fri, 21 Apr 2023 19:48:48 -0400
X-MC-Unique: ZgalExy5NyWxRbHjCf5mdQ-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5067d65c251so2143448a12.2
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 16:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682120926; x=1684712926;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ty3XjvTMJPmSzqLtzAvHrgacbo7grKCh8Eml4uSwPk=;
        b=e6NFPPA09G/cYCR+OLBZWvLCuwnQaFw6MP6YjzRCNdwdGywqbnlphML+M4vSKYcc84
         jk5mmSoU2TsVXUyxBQT3SD353aspNsLWLbljf/5S6OdBvpPvJrhpLPrcmG9iXxwBNrk9
         DW20rbCIcP/eIe810UO7svm3zEf0iQRZLsfDxnSvNvenFoPBjpWP9iaPfgVmALT3OJ+n
         Br9JvlaJSk5CeacUM7yXkJkySAk/HsbE3eIn9G17hGiDDxEAtnhXAJY4pwgbABhU7bp4
         9tnxvlNErIuK5RzVxfADPacDnsjsdwrKVndYkdwtjpU6KnZ41QS9J/ARyaJJr3XbCJt1
         BaHg==
X-Gm-Message-State: AAQBX9cZPbybfpHWXmEiZj5xsAev7g1n41A1s1iWkyXwp2asYJ+9VsqM
        32YMpxpDLREAuTxgXDWaEkdqrnj55dKIXB8mV4+LualDXVwycyL7u36gJBwcimj1VylPKv3WMip
        gtHcUimQh9D/kRBDIPPdD9nU=
X-Received: by 2002:a05:6402:406:b0:504:9ae7:f73b with SMTP id q6-20020a056402040600b005049ae7f73bmr6320560edv.2.1682120926461;
        Fri, 21 Apr 2023 16:48:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350bQiDrXCeb3AVQZHzRjNCYJLBEvIpaSPIfzKrEy+gmC4jF54imKHYHzGxmVxfOSU8RTdIR3pQ==
X-Received: by 2002:a05:6402:406:b0:504:9ae7:f73b with SMTP id q6-20020a056402040600b005049ae7f73bmr6320551edv.2.1682120926126;
        Fri, 21 Apr 2023 16:48:46 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id n20-20020aa7d054000000b004fc01b0aa55sm2340156edo.4.2023.04.21.16.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 16:48:45 -0700 (PDT)
Message-ID: <100c4e47-9d8d-8b3a-b70b-c0498febf23c@redhat.com>
Date:   Sat, 22 Apr 2023 01:48:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <ZELftWeNUF1Dqs3f@linux.dev>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Getting the kvm-riscv tree in next
In-Reply-To: <ZELftWeNUF1Dqs3f@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/23 21:10, Oliver Upton wrote:
> I've also noticed that for the past few kernel release cycles you've
> used an extremely late rc (i.e. -rc7 or -rc8), which I fear only
> draws more scrutiny.

Heh, I just wrote the same thing to Anup.  In particular, having 
kvm-riscv in next (either directly or by sending early pull requests to 
me) would have helped me understand the conflicts between the core and 
KVM trees for RISC-V, because Stephen Rothwell would have alerted me 
about them.

Paolo

