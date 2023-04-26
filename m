Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34C56EF69D
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241448AbjDZOmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241032AbjDZOmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:42:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A9C6E91
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682520075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rw5ho5mwvwSpm9v3WGtv3HXG+WbvPdFGq3pf5ZM8clA=;
        b=DRo/qtUliojJ4xYuQ8BDkANMafLW5iQxOXyNjRtiVmgb6E/rDf1vyn83DmrxjrDFrKLYQk
        tig4KQosECmX43VPhbKqO6ZTMpZONb1wSh1fDppcyMthc5qN7+9D71hMLn1Dr3jROe8oLq
        qlRIRItaWO7MnxR3f8ycimI4OYlAs3Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-k9PsOySvOeGmYEOtH90Eng-1; Wed, 26 Apr 2023 10:41:13 -0400
X-MC-Unique: k9PsOySvOeGmYEOtH90Eng-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2f625d521abso4044813f8f.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682520072; x=1685112072;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rw5ho5mwvwSpm9v3WGtv3HXG+WbvPdFGq3pf5ZM8clA=;
        b=GeJbkcLMPpBZxxONxMECubgGZ5pYRBuph08LLvSLzSinU87+dsSldWNOrChC8xk6mr
         7h+xpajbws6Mi+ONFqoEWz4j429rJS9qSBXHqfRuh9URM76HlINzS3TRXWc8WJ0nGd3o
         ZpyD4kGtZkRQUoqhsaXezF7zHx/wpzp8d7rR1NBd+tcpU0NCUiYV6WHD3JjMLa27ia3A
         c/WMK3cVcJ03Ora3RNwxa/Rals+A/I7sFTm/RHJNOk1nDg/426ayK8dJw7uxqqrnVN1I
         McxRZKwPrphiuxqdjUaImpQGvZCfZBxYNyX+s4nLVNiZm+AUPM13Khsip0J9w935tiHC
         SnbQ==
X-Gm-Message-State: AAQBX9cRyXTvEConUExgoQZq6SEBpu/uiXIakZ5m1hYe2oPqGkpj71Fw
        ndrCabJoXwKHp35gBgLvWO9u52JYNCCdgYiYYAqaAD9xvXAaKF9j14YVl72zZ1abaS6Um8PuB2b
        qLSyldJhDCwaQH0sFR+zL
X-Received: by 2002:a5d:6808:0:b0:2fa:26cc:71f0 with SMTP id w8-20020a5d6808000000b002fa26cc71f0mr15964701wru.10.1682520072589;
        Wed, 26 Apr 2023 07:41:12 -0700 (PDT)
X-Google-Smtp-Source: AKy350aqBpS/vpvv+d2wW1MZx7Uk6NEYw6d+ESAJH7f83enn4uexW+IXYVB+szvLL0CpVVAd9vh4zw==
X-Received: by 2002:a5d:6808:0:b0:2fa:26cc:71f0 with SMTP id w8-20020a5d6808000000b002fa26cc71f0mr15964681wru.10.1682520072291;
        Wed, 26 Apr 2023 07:41:12 -0700 (PDT)
Received: from [192.168.0.5] (ip-109-43-176-131.web.vodafone.de. [109.43.176.131])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d6892000000b002f9bfac5baesm16051395wru.47.2023.04.26.07.41.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 07:41:11 -0700 (PDT)
Message-ID: <243608a7-484c-4844-9274-0b02dc32ec25@redhat.com>
Date:   Wed, 26 Apr 2023 16:41:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH] clang-format: add project-wide
 configuration file
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
References: <20230426140805.704491-1-seiden@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230426140805.704491-1-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/2023 16.08, Steffen Eiden wrote:
> clang-format is a tool to format C/C++/... code according to a set of
> rules and heuristics.
> 
> This commit adds the configuration file, with the setting the
> Linux kernel project uses "as of today", with the modification
> of allowing up to 120 chars per line.
> 
> This hopefully eases code formatting for developers, as clang-format
> has support for most editors and also can be run standalone.
> 
> Additional information:
>      https://clang.llvm.org/docs/ClangFormat.html
>      https://clang.llvm.org/docs/ClangFormatStyleOptions.html
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   .clang-format | 688 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 688 insertions(+)
>   create mode 100644 .clang-format
> 
> diff --git a/.clang-format b/.clang-format
> new file mode 100644
> index 0000000..71c7830
> --- /dev/null
> +++ b/.clang-format
> @@ -0,0 +1,688 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# clang-format configuration file. Intended for clang-format >= 11.
> +#
> +# For more information, see:
> +#
> +#   Documentation/process/clang-format.rst
> +#   https://clang.llvm.org/docs/ClangFormat.html
> +#   https://clang.llvm.org/docs/ClangFormatStyleOptions.html
> +#
> +---
> +AccessModifierOffset: -4
> +AlignAfterOpenBracket: Align
> +AlignConsecutiveAssignments: false
> +AlignConsecutiveDeclarations: false
> +AlignEscapedNewlines: Left
> +AlignOperands: true
> +AlignTrailingComments: false
> +AllowAllParametersOfDeclarationOnNextLine: false
> +AllowShortBlocksOnASingleLine: false
> +AllowShortCaseLabelsOnASingleLine: false
> +AllowShortFunctionsOnASingleLine: None
> +AllowShortIfStatementsOnASingleLine: false
> +AllowShortLoopsOnASingleLine: false
> +AlwaysBreakAfterDefinitionReturnType: None
> +AlwaysBreakAfterReturnType: None
> +AlwaysBreakBeforeMultilineStrings: false
> +AlwaysBreakTemplateDeclarations: false
> +BinPackArguments: true
> +BinPackParameters: true
> +BraceWrapping:
> +  AfterClass: false
> +  AfterControlStatement: false
> +  AfterEnum: false
> +  AfterFunction: true
> +  AfterNamespace: true
> +  AfterObjCDeclaration: false
> +  AfterStruct: false
> +  AfterUnion: false
> +  AfterExternBlock: false
> +  BeforeCatch: false
> +  BeforeElse: false
> +  IndentBraces: false
> +  SplitEmptyFunction: true
> +  SplitEmptyRecord: true
> +  SplitEmptyNamespace: true
> +BreakBeforeBinaryOperators: None
> +BreakBeforeBraces: Custom
> +BreakBeforeInheritanceComma: false
> +BreakBeforeTernaryOperators: false
> +BreakConstructorInitializersBeforeComma: false
> +BreakConstructorInitializers: BeforeComma
> +BreakAfterJavaFieldAnnotations: false
> +BreakStringLiterals: false
> +ColumnLimit: 120
> +CommentPragmas: '^ IWYU pragma:'
> +CompactNamespaces: false
> +ConstructorInitializerAllOnOneLineOrOnePerLine: false
> +ConstructorInitializerIndentWidth: 8
> +ContinuationIndentWidth: 8
> +Cpp11BracedListStyle: false
> +DerivePointerAlignment: false
> +DisableFormat: false
> +ExperimentalAutoDetectBinPacking: false
> +FixNamespaceComments: false
> +
> +# Taken from:
> +#   git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' include/ tools/ \
> +#   | sed "s,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'," \
> +#   | LC_ALL=C sort -u
> +ForEachMacros:
> +  - '__ata_qc_for_each'
> +  - '__bio_for_each_bvec'
> +  - '__bio_for_each_segment'
> +  - '__evlist__for_each_entry'
> +  - '__evlist__for_each_entry_continue'
> +  - '__evlist__for_each_entry_from'
> +  - '__evlist__for_each_entry_reverse'
> +  - '__evlist__for_each_entry_safe'
> +  - '__for_each_mem_range'
> +  - '__for_each_mem_range_rev'
> +  - '__for_each_thread'
> +  - '__hlist_for_each_rcu'
> +  - '__map__for_each_symbol_by_name'
> +  - '__perf_evlist__for_each_entry'
> +  - '__perf_evlist__for_each_entry_reverse'
> +  - '__perf_evlist__for_each_entry_safe'
> +  - '__rq_for_each_bio'
> +  - '__shost_for_each_device'
...

I think this ForEachMacros list should be adapted for the k-u-ts.
The "git grep" statement results in this list for the k-u-ts:

   - 'dt_for_each_subnode'
   - 'fdt_for_each_property_offset'
   - 'fdt_for_each_subnode'
   - 'for_each_cpu'
   - 'for_each_online_cpu'
   - 'for_each_present_cpu'

which is definitely much shorter :-)

  Thomas

