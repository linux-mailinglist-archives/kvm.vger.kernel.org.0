Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856A56564A5
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 19:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLZSgj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 13:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiLZSgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 13:36:38 -0500
Received: from out-130.mta0.migadu.com (out-130.mta0.migadu.com [IPv6:2001:41d0:1004:224b::82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3038BCF
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 10:36:36 -0800 (PST)
Date:   Mon, 26 Dec 2022 19:36:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672079794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6FGyTzLUpkggnG98YSAiISPSA1GhvoPwvtxXGBHsN/4=;
        b=Psi9Nzv4vfsMxKuCxRGxiHqv1kPrC9zgfVXXtRkBkISIMKKMFcf/iDQbIvjeccqp2UGfjy
        /FJkDJpMdUolgmhhSJUgAkjj+G1ACpTgauaoKJW9Xsdpu/s0gNs+CzIHIh7GF+uzO8uvzp
        HyTvOrEqO5MuKMuP6wVzJg5fldKwmdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, nrb@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20221226183634.7qr7f4otucfzat5g@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220175508.57180-1-imbrenda@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 06:55:08PM +0100, Claudio Imbrenda wrote:
> A recent patch broke make standalone. The function find_word is not
> available when running make standalone, replace it with a simple grep.
> 
> Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  scripts/s390x/func.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index 2a941bbb..6c75e89a 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -21,7 +21,7 @@ function arch_cmd_s390x()
>  	"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
>  
>  	# run PV test case
> -	if [ "$ACCEL" = 'tcg' ] || find_word "migration" "$groups"; then
> +	if [ "$ACCEL" = 'tcg' ] || grep -q "migration" <<< "$groups"; then

What about the '-F' that find_word has?

>  		return
>  	fi
>  	kernel=${kernel%.elf}.pv.bin
> -- 
> 2.38.1
> 
