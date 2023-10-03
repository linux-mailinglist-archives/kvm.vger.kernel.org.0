Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3C0A7B6B04
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbjJCOGb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjJCOGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:06:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8515EA9
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 07:06:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 377331F893;
        Tue,  3 Oct 2023 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696341986; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDqJJ7En9jpnR2yY7FEvE4WtOXHGKqVVku0MzHnFxxY=;
        b=Nmtpy5I7ShAx9L2pFSQVTaTin1lA9WI5FR0aEGyPwfePJcn3o5yMx+5kSeFJGbi7AlCn7m
        PTXtGZH6irdyYzot33+92rjEmq31Yjw28oYtZ0mo9zMhGiRcIX3urkEwmy6n4zNp1WP4Ri
        yNyXHQI8YcQ/6p9eD/PnXfeubfR6Hs0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696341986;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDqJJ7En9jpnR2yY7FEvE4WtOXHGKqVVku0MzHnFxxY=;
        b=Pi+C9WA3kmRlnhk2VAFAkPsWVlVG5bI7I6Z4kM0T765yVUr/wZS3kPXvmWKPBBkTr3DTpz
        t28iw5MxCMOL+nDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB9AD139F9;
        Tue,  3 Oct 2023 14:06:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id puMOMOEfHGU+SgAAMHmgww
        (envelope-from <cfontana@suse.de>); Tue, 03 Oct 2023 14:06:25 +0000
Message-ID: <5a937be2-0e20-6506-7de4-956b4759478f@suse.de>
Date:   Tue, 3 Oct 2023 16:06:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 0/7] accel: Restrict tcg_exec_[un]realizefn() to TCG
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20231003123026.99229-1-philmd@linaro.org>
From:   Claudio Fontana <cfontana@suse.de>
In-Reply-To: <20231003123026.99229-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nice. I build-tested and make checked this as well,

Reviewed-by: Claudio Fontana <cfontana@suse.de>
Tested-by: Claudio Fontana <cfontana@suse.de>

On 10/3/23 14:30, Philippe Mathieu-Daudé wrote:
> Since v1:
> - Use 'target'/'common' in function names (Claudio)
> - Added Claudio R-b tags
> 
> From v1:
> - Add missing accel_cpu_common_unrealize()
> - Add AccelClass::cpu_common_[un]realize handlers
> - Use tcg_exec_[un]realizefn as AccelClass handlers
> 
> Philippe Mathieu-Daudé (7):
>   accel: Rename accel_cpu_realizefn() ->  accel_cpu_realize()
>   accel: Rename AccelCPUClass::cpu_realizefn() -> cpu_target_realize()
>   accel: Rename accel_cpu_realize() -> accel_cpu_common_realize()
>   accel: Introduce accel_cpu_common_unrealize() stub
>   accel: Declare AccelClass::cpu_common_[un]realize() handlers
>   accel/tcg: Have tcg_exec_realizefn() return a boolean
>   accel/tcg: Restrict tcg_exec_[un]realizefn() to TCG
> 
>  accel/tcg/internal.h        |  3 +++
>  include/exec/cpu-all.h      |  2 --
>  include/hw/core/accel-cpu.h |  2 +-
>  include/qemu/accel.h        | 12 ++++++++++--
>  accel/accel-common.c        | 27 ++++++++++++++++++++++++---
>  accel/tcg/cpu-exec.c        |  4 +++-
>  accel/tcg/tcg-all.c         |  2 ++
>  cpu.c                       | 13 +++----------
>  target/i386/hvf/hvf-cpu.c   |  2 +-
>  target/i386/kvm/kvm-cpu.c   |  4 ++--
>  target/i386/tcg/tcg-cpu.c   |  2 +-
>  11 files changed, 50 insertions(+), 23 deletions(-)
> 

