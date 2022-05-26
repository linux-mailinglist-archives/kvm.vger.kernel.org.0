Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5453538E
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 20:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345441AbiEZSsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344725AbiEZSs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 14:48:29 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C453FDBD
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 11:48:28 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e66so2002690pgc.8
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 11:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9pDHvj1XxxhOT7SmEuncoL4fkxjfq02ZHdILpMB+Yqk=;
        b=AWyVlkEQOxwNz1MnnmC2HSRXrWV4qLE/tSUFKUA5CxWYEyKYkJ0sYFUxZdGmLkWTU9
         FASK2jAF85CEA9G1j/08T3WJc/HvItteUfELobE3U52nZ8qC8+WVCVl9X/v3TLOVXWLh
         Qibuchji5GBb1ao1goX8DxgVrbTf0PlCwPwZSQfMYmMGF7z7bRYbazfgoZsISrhg6P5W
         edh3l4S4XBB69heiFO8KULJDg0ZDYqhMnGEsZ5aSXKGNn4Or4/HJ3ueFgKSQa3Q0MacJ
         3SUDb4ZashNOr68XsFixG9EWarxPXXEELibBjbHBPHc4k2LWAOE1n7oHjdVOoiy696vW
         bf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9pDHvj1XxxhOT7SmEuncoL4fkxjfq02ZHdILpMB+Yqk=;
        b=tZZQjPfrevtUjMZzkadQXiiK0KM+i+XTwlIcdJFP06KX+Rrd7npuUlq8aJMlZMH3Kk
         +4vjocqpAvgpdsEHwIHbgOGq0xKK19ItqeNvIjRG7KGkDOCehOvoe6wJaFfOdC+Kk/Oc
         PFuTiG88u7Ja889zMf8BvPXBlhIoU5JsaXz6dmTUjLraP4zqjuASDxQggNQf/BSuQMX6
         1gJ8yRWGo0Scd+KpmEn1xrn27YHSxhy1us2CLc8OTx3+4vfstkUVLbZm4Q8lNxpohbx+
         mJJEYCJ8J9rMNZ8OE0bCEg1oPtX47IIRPKzTa4O36FagOORK5H3GjaJWYob9wH6Wn95v
         9Q+Q==
X-Gm-Message-State: AOAM531fuwbSTtVUKQiuDlcLWoum45aCYcduelSjwveqPwcPAlyuIO8+
        to4LHR1H/lR3Oj8sVWwyHNU=
X-Google-Smtp-Source: ABdhPJyXkuSg36ceN28P/J4sn1ckXXAif4FzPZkUa/h+vjfeXWI6pf7034wNAaw0jgvjdEUiPX80sA==
X-Received: by 2002:a63:e516:0:b0:3fa:dc6:7ace with SMTP id r22-20020a63e516000000b003fa0dc67acemr22497686pgh.215.1653590908282;
        Thu, 26 May 2022 11:48:28 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id q3-20020a056a0002a300b0050dc7628167sm1841386pfs.65.2022.05.26.11.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 11:48:27 -0700 (PDT)
Date:   Thu, 26 May 2022 11:48:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 22/36] i386/tdx: Track RAM entries for TDX VM
Message-ID: <20220526184826.GA3413287@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-23-xiaoyao.li@intel.com>
 <20220524073729.xkk6s4tjkzm77wwz@sirius.home.kraxel.org>
 <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5e457e0b-dc23-9e5b-de89-0b137e2baf7f@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 03:33:10PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 5/24/2022 3:37 PM, Gerd Hoffmann wrote:
> > I think all this can be simplified, by
> >    (1) Change the existing entry to cover the accepted ram range.
> >    (2) If there is room before the accepted ram range add a
> >        TDX_RAM_UNACCEPTED entry for that.
> >    (3) If there is room after the accepted ram range add a
> >        TDX_RAM_UNACCEPTED entry for that.
> 
> I implement as below. Please help review.
> 
> +static int tdx_accept_ram_range(uint64_t address, uint64_t length)
> +{
> +    uint64_t head_start, tail_start, head_length, tail_length;
> +    uint64_t tmp_address, tmp_length;
> +    TdxRamEntry *e;
> +    int i;
> +
> +    for (i = 0; i < tdx_guest->nr_ram_entries; i++) {
> +        e = &tdx_guest->ram_entries[i];
> +
> +        if (address + length < e->address ||
> +            e->address + e->length < address) {
> +                continue;
> +        }
> +
> +        /*
> +         * The to-be-accepted ram range must be fully contained by one
> +         * RAM entries
> +         */
> +        if (e->address > address ||
> +            e->address + e->length < address + length) {
> +            return -EINVAL;
> +        }
> +
> +        if (e->type == TDX_RAM_ADDED) {
> +            return -EINVAL;
> +        }
> +
> +        tmp_address = e->address;
> +        tmp_length = e->length;
> +
> +        e->address = address;
> +        e->length = length;
> +        e->type = TDX_RAM_ADDED;
> +
> +        head_length = address - tmp_address;
> +        if (head_length > 0) {
> +            head_start = e->address;
> +            tdx_add_ram_entry(head_start, head_length, TDX_RAM_UNACCEPTED);

tdx_add_ram_entry() increments tdx_guest->nr_ram_entries.  I think it's worth
for comments why this is safe regarding to this for-loop.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
