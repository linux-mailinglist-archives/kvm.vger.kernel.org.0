Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7996250A4E4
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 17:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390383AbiDUQCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiDUQCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:02:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E445441304
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650556760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WbKI/RdoVw2lSsvxFHaHaKTcTYkUQmqIRbVC6EXdVms=;
        b=gtqqwq1T9A+76a1QW7VCZjEWz9OzWW6VlXj/S/fwJpJwcbL1BQH7WpQfVjKZnn4vBcXELo
        MfVgDPGR8JCVlvoTHs7nFOsoz5HmD3aiXPbYDfE+3OPY2PWEcEHHGuY/4gZ1AJ2ceJJtNX
        6f0F1F8VE29K59jiRR1Ckvzo8N638WI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-qRFjIEikPeWCH0-hoIJpAQ-1; Thu, 21 Apr 2022 11:59:19 -0400
X-MC-Unique: qRFjIEikPeWCH0-hoIJpAQ-1
Received: by mail-wr1-f71.google.com with SMTP id q18-20020adfab12000000b0020ab3d0f72fso1079111wrc.20
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 08:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WbKI/RdoVw2lSsvxFHaHaKTcTYkUQmqIRbVC6EXdVms=;
        b=D/lmfxFwjV9nlqPRF6VUr+532LWIA7Y78s+7kg+vszmvhO9VJqaTtJ//yvGI6K/SbZ
         SArSSXhVYzxnT9t45lCH0H9PzbDjL7Udfhj8sWI5RkXJ6FtgHraxBJ3eeqa1KPb7FuqI
         jvlmlma5idWT4cmKDG5l9hQaKMhuBDv9//u20yoM4RJIiAnXvIw0nKEqiNqiH5RCiWro
         Ubi8746wIn/D5S3axuP83xdKUrhvEXtjLLyeI7yzWfjDYoDGzWiamv2DjrIytAGvv6KR
         oXXICDv505XYD6NJaZiKAfceSaMg92LCIcLTCAnNxloPEIj1PACRldrNZEn81bs7v0FN
         1PuA==
X-Gm-Message-State: AOAM530Rt9EuLeBPq8FzbMzhsef3CQA+NUSLgl3rdwNB2Wk0+XudRn9Q
        /GT3WBgeKavbRrQ1o8pt9zir+Fy/ttz24Hla/n2ir/gDWZ7KqohkJZHv0pjA1JHU0u2ACLgB5GZ
        pvzvvpqv3j5Ax
X-Received: by 2002:a05:600c:5114:b0:38e:bd9c:9cb0 with SMTP id o20-20020a05600c511400b0038ebd9c9cb0mr9033218wms.153.1650556758133;
        Thu, 21 Apr 2022 08:59:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJYpmuXXnj3iai3nELwusouPJpP3ycfIrIkjSpW41bWM35mI3RLKAy/kKPMd6YY2jG5N59ZA==
X-Received: by 2002:a05:600c:5114:b0:38e:bd9c:9cb0 with SMTP id o20-20020a05600c511400b0038ebd9c9cb0mr9033199wms.153.1650556757917;
        Thu, 21 Apr 2022 08:59:17 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id bi7-20020a05600c3d8700b0038eb78569aasm2252457wmb.20.2022.04.21.08.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 08:59:17 -0700 (PDT)
Message-ID: <b8788b72-12bf-136b-00d4-8e5decc9eb16@redhat.com>
Date:   Thu, 21 Apr 2022 17:59:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.18, take #2
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>
References: <CAAhSdy3io3CdxTDGRVCijO-R2V=GBOukOEs+BH6wYnkT2_iPMw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy3io3CdxTDGRVCijO-R2V=GBOukOEs+BH6wYnkT2_iPMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 17:32, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-fixes-5.18-2

Pulled, thanks.

Paolo

