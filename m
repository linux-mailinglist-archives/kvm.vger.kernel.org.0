Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6EB27AD5A
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 13:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgI1L46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 07:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34377 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbgI1L45 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 07:56:57 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601294216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UYpEXkVaWDf4SEEAIFZw1peKIq/qLwFpOsrbsnHmNvM=;
        b=WaLn9CvzhIqp4L/DeUi7jZFAGegoQsYii6wZ2GMKQLrxkPB7TsOfEwFtELcC6dEENEdr7u
        KqHXTXGiCTxVTXYw9M2fK9ueKNWH2IlZBdIHXuw8tPqzdwh5PzTO3OJ+9fwAxFVCfFG4rt
        Pm0qMITSa+MaUP06YSjWPNUnNJpZ2WE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-mr5vJs3AN6-S3lYiTUwOZw-1; Mon, 28 Sep 2020 07:56:54 -0400
X-MC-Unique: mr5vJs3AN6-S3lYiTUwOZw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CFDD1084D81
        for <kvm@vger.kernel.org>; Mon, 28 Sep 2020 11:56:53 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2C0A5D9CA;
        Mon, 28 Sep 2020 11:56:51 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] runtime.bash: fix check for parameter
 files
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200928113412.2419974-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <bae8fcde-a07f-ddfe-d9b9-e2177180d720@redhat.com>
Date:   Mon, 28 Sep 2020 13:56:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200928113412.2419974-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/09/2020 13.34, Paolo Bonzini wrote:
> We need to check if the file exists, not just if it is a non-empty string.
> While an empty $path would have the unfortunate effect that "cat" would
> read from stdin, that is not an issue as you can simply not do that.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 294e6b1..3121c1f 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,7 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
>              print_result "SKIP" $testname "" "$path not equal to $value"
>              return 2
>          fi

Reviewed-by: Thomas Huth <thuth@redhat.com>

