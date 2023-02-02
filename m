Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47152687707
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 09:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbjBBILG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 03:11:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBBILE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 03:11:04 -0500
Received: from out-232.mta1.migadu.com (out-232.mta1.migadu.com [IPv6:2001:41d0:203:375::e8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C469B2D149
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 00:11:00 -0800 (PST)
Date:   Thu, 2 Feb 2023 09:10:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675325458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ie5uGvKIrofRgo6t7ShvhGoGSYw5hlV+UY54sbIh3c=;
        b=MIMPAxDX5vZ3dkfPsO5DiRiiDEsk2io0Wb+spRESH22N1RK+B0qcCw5ySRYA0QYYrt5Wri
        bXpfIvuVDvV7/qfqpo09eYrX55QilXOgEb8KPX+NUqADcozuYKIG89w6RHCe83648Y/LfS
        XdJR7sQKJ9vwOovXTocnlEnILFFPTtE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     shahuang@redhat.com
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] selftests: KVM: Replace optarg with arg in
 guest_modes_cmdline
Message-ID: <20230202081057.nanfjavyy2l4pswc@orel>
References: <20230202025716.216323-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202025716.216323-1-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 02, 2023 at 10:57:15AM +0800, shahuang@redhat.com wrote:
> From: Shaoqin Huang <shahuang@redhat.com>
> 
> The parameter arg in guest_modes_cmdline not being used now, and the
> optarg should be replaced with arg in guest_modes_cmdline.
> 
> And this is the chance to change strtoul() to atoi_non_negative(), since
> guest mode ID will never be negative.

Fixes: e42ac777d661 ("KVM: selftests: Factor out guest mode code")

> 
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> 
> ---
> Changes from v1:
>   - Change strtoul() to atoi_non_negative(). [Vipin]
> 
> ---
>  tools/testing/selftests/kvm/lib/guest_modes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index 99a575bbbc52..1df3ce4b16fd 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -127,7 +127,7 @@ void guest_modes_cmdline(const char *arg)
>  		mode_selected = true;
>  	}
>  
> -	mode = strtoul(optarg, NULL, 10);
> +	mode = atoi_non_negative("Guest mode ID", arg);
>  	TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
>  	guest_modes[mode].enabled = true;
>  }
> -- 
> 2.39.0
> 

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
