Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4B46473B0
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 16:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiLHP6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 10:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiLHP6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 10:58:44 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375B75E9FD
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 07:58:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E6D7022BBE;
        Thu,  8 Dec 2022 15:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670515121; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9SOScxXH7FngR4nroCXALSqtojX7LBnIMJzGT02/F0=;
        b=tRfIS1vA6tfY3J/gm/NyVmspa2C3OJk5fV7/dk7IYzv7WJPkQWdNyqpCS1SAopWR9U+vBw
        h0dsBMhSbT5R6NFRbqFMvJapBMUqhnCSkpziTbCc8c+qJv815jyt/LKqmOG8LM9h2G6Ngd
        TjQDWUtE1Hb14VYiII1B/5h8+nEoXL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670515121;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e9SOScxXH7FngR4nroCXALSqtojX7LBnIMJzGT02/F0=;
        b=6kw5RQ3ql5hb0RguKvs1CLb497VKUn8lUEiC641b65WBz2fIpGfeT1CYPQ8IPSk5Mbnklu
        7x1Qy2QHLxgI2QBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 648D7138E0;
        Thu,  8 Dec 2022 15:58:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EQa3CrEJkmNMGQAAMHmgww
        (envelope-from <farosas@suse.de>); Thu, 08 Dec 2022 15:58:41 +0000
From:   Fabiano Rosas <farosas@suse.de>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Greg Kurz <groug@kaod.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Stafford Horne <shorne@gmail.com>,
        Anton Johansson <anjo@rev.ng>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        qemu-ppc@nongnu.org, Eduardo Habkost <eduardo@habkost.net>,
        Chris Wulff <crwulff@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Marek Vasut <marex@denx.de>, Max Filippov <jcmvbkbc@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Laurent Vivier <laurent@vivier.eu>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>
Subject: Re: [PATCH-for-8.0 v2 2/4] gdbstub: Use vaddr type for generic
 insert/remove_breakpoint() API
In-Reply-To: <20221208153528.27238-3-philmd@linaro.org>
References: <20221208153528.27238-1-philmd@linaro.org>
 <20221208153528.27238-3-philmd@linaro.org>
Date:   Thu, 08 Dec 2022 12:58:38 -0300
Message-ID: <87mt7xubtd.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Both insert/remove_breakpoint() handlers are used in system and
> user emulation. We can not use the 'hwaddr' type on user emulation,
> we have to use 'vaddr' which is defined as "wide enough to contain
> any #target_ulong virtual address".
>
> gdbstub.c doesn't require to include "exec/hwaddr.h" anymore.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Fabiano Rosas <farosas@suse.de>
