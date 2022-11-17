Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41AC62E981
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 00:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240461AbiKQXXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 18:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235099AbiKQXXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 18:23:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE0472985;
        Thu, 17 Nov 2022 15:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D3ACB82225;
        Thu, 17 Nov 2022 23:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56D1C433C1;
        Thu, 17 Nov 2022 23:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668727383;
        bh=QA1JXitB9AIw7tbgQsE7vhfy0/BpusWb8idjnRV7OHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZMzld3YNNTmh9dDWJ3eqj7QQCvW8Jc0UKKEZcw+NBzL1mLiKMEUekM77ycegxJ5A
         oc0ClPKobQBiROk4ubyIUZeiZCduoiSqEFoGoee7mUGCb4xsJhWTD17Yv7XLIp3YlC
         rZ+9JQmY9PExLWJR0RlQZXSsncEgApMIK9l+IJDUi/dU9A2F38kuTFOTJLhTrbeQii
         0RRvMZj75kItz/d8/Dzjzi/TCd8xblBkMzIx1bedcD35AKNEJ2e57pJK3dfwHbmAKA
         RL4n6KBLFFsy+YIJWRL27Fk6dmOlsW6vhOkX+2tpeVV4k1vdMj/xSyatVWWqPg8OEq
         xXKuueALeQL2g==
Date:   Thu, 17 Nov 2022 15:22:08 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, x86@kernel.org
Subject: Re: VMX HOST_RIP target alignment
Message-ID: <20221117232208.26ha4tjizeegcbwr@treble>
References: <Y3adkSe/J70PqUyt@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3adkSe/J70PqUyt@p183>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 11:46:09PM +0300, Alexey Dobriyan wrote:
> One of the side effects of fixing retbleed for VMX was demoting
> HOST_RIP target from honorable function to a lowly label:
> 
> 	-SYM_FUNC_START(vmx_vmexit)
> 	+SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
> 
> ffffffff81243c49:       0f 01 c2                vmlaunch
> ffffffff81243c4c:       e9 a7 00 00 00          jmp    ffffffff81243cf8 <vmx_vmexit+0xa7>
> 
> ffffffff81243c51 <vmx_vmexit>:
> ffffffff81243c51:       50                      push   rax
> 
> Now I've never measured VM exit latency but is it important to align it
> at 16 bytes like Intel recommends for functions?

Yes, I'd think we should restore the alignment to 16 bytes again, that
change was definitely not intentional.

-- 
Josh
