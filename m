Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A98643D08
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 07:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiLFGOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 01:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiLFGOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 01:14:51 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF162717A
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 22:14:49 -0800 (PST)
Date:   Tue, 6 Dec 2022 07:14:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670307287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xc9N9eHhbsTVbBpxVTxBcP4hqjGOw5rLQv1xrjVt9js=;
        b=kA8AlTu+7Txikfb5x2fpF/92aENk6OAdI8fW179Sbf79qfnnK7OhYBg+0uT3gdkOa9/WMz
        YuBQqtWznj/dw0BltOUo+T7gOKEFmz9/9lTVcOkpTo1sndU2WP3jdZ3RyOXOdi6vaOQpPS
        ypOCO/prE74NwWQVzLLj2gf96dPS+O4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Greg Thelen <gthelen@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] avoid encoding mtime in standalone scripts
Message-ID: <20221206061446.cjw77xc73anhenjm@kamzik>
References: <20221205162840.535675-1-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205162840.535675-1-gthelen@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 08:28:40AM -0800, Greg Thelen wrote:
> Reproducible builds aid in caching builds and tests. Ideally rebuilding
> the same source produces identical outputs.
> 
> The standalone kvm test scripts contain base64 encoded gzip compressed
> test binaries. Compression and encoding is done with
> "gzip -c FILE | base64" which stores FILE's name and mtime in the
> compressed output.
> 
> Binaries are expanded with
>   base64 -d << 'BIN_EOF' | zcat > OUTPUT
> This expansion pipeline ignores the gzip stored name and mtime.
> 
> Use "gzip -n" to avoid saving mtime in the output. This makes the
> standalone test scripts reproducible. Their contents are the same
> regardless of when they are built.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  scripts/mkstandalone.sh | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index 86c7e5498246..1e6d308b43f7 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -16,7 +16,8 @@ temp_file ()
>  	echo "cleanup=\"\$$var \$cleanup\""
>  	echo "base64 -d << 'BIN_EOF' | zcat > \$$var || exit 2"
>  
> -	gzip -c "$file" | base64
> +	# For reproductible builds avoid saving $file mtime with -n
> +	gzip -nc "$file" | base64
>  
>  	echo "BIN_EOF"
>  	echo "chmod +x \$$var"
> -- 
> 2.39.0.rc0.267.gcb52ba06e7-goog
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
