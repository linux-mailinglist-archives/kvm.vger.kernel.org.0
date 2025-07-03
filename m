Return-Path: <kvm+bounces-51478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB0CAF725F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA5641C837C8
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EEBC2E612F;
	Thu,  3 Jul 2025 11:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="pTUh2OSr"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458E22E49AF
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542335; cv=none; b=b01fC8iEy04LqlTst3cW0jTXpXaxji5cIgnkkbRYUZCpNkxn8aWr9K8FX1+8B8xKfenor24v2t9MHvl4Tbl/JRhv36bv5FK2Lu1Clw6MXKM9wtsMLFPX+W9GaiXUfdFOvTQlHoWok9+zXwRJqJAM+OIMNUOWfZMgcC35dkNduuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542335; c=relaxed/simple;
	bh=gEtf5mETds+RSiNQZPtckLS42VAxxRHRuMHSwYJho3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/J/48B9McNSInCWwZj+I7wA5IxctC0cJ/7nkiD7LT+b9y0VxLoBP9EzWCPCviXUrqMDy5QLGAjv/XdSL99Tw4qgh8UwORmkg5qJDux1uHfHhWJygKZUyGKEypjG/Xoh9AVQ3ENklaedT/AFhF9W/rikIE85fJMxZpgJGxEzRws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=pTUh2OSr; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=ddlCtZR0+hZ41Fp5P3ea9W0RE4pvU3NEq8jcXcphVUw=; b=pTUh2OSre5DeO0IO
	RfPMIJtCimXFewCmnf7+CS/uWjtK/RyEbhF1X50/vSj+9uNrH368+zUllZSgnZnco4ojcKd2VdZmu
	XGgBuyUKrRnzWhhkqc8yV7f2qHVb9/WBtUUF3kMsoOzUvgUOdqeYW4F5wEOLigtVvizzdGgF1v2RU
	7B/KJGJCAa0GbEcEZQTUYMNt4yyAAqGUc3B2X4KBKr16KuV3gLM3FqyBJoWdv1QecygEXIICfwIOO
	kLT5zZzMrsXV/vtDBIZkhRS4pb9cAmw+YWgrHpdQZqL7Qv+ou1b6t817ies7fLVx4y12TDbWzAxFO
	wgdCzokpSUEQKpUnFA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uXIAj-00DqzF-24;
	Thu, 03 Jul 2025 11:32:09 +0000
Date: Thu, 3 Jul 2025 11:32:09 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v5 23/69] accel/tcg: Remove 'info opcount' and
 @x-query-opcount
Message-ID: <aGZqObkB6cBqo2tv@gallifrey>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-24-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703105540.67664-24-philmd@linaro.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 11:32:00 up 66 days, 19:45,  1 user,  load average: 0.10, 0.03, 0.01
User-Agent: Mutt/2.2.12 (2023-09-09)

* Philippe Mathieu-Daudé (philmd@linaro.org) wrote:
> Since commit 1b65b4f54c7 ("accel/tcg: remove CONFIG_PROFILER",
> released with QEMU v8.1.0) we get pointless output:
> 
>   (qemu) info opcount
>   [TCG profiler not compiled]
> 
> Remove that unstable and unuseful command.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

For HMP
Acked-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  qapi/machine.json          | 18 ------------------
>  accel/tcg/monitor.c        | 21 ---------------------
>  tests/qtest/qmp-cmd-test.c |  1 -
>  hmp-commands-info.hx       | 14 --------------
>  4 files changed, 54 deletions(-)
> 
> diff --git a/qapi/machine.json b/qapi/machine.json
> index d5bbb5e367e..acf6610efa5 100644
> --- a/qapi/machine.json
> +++ b/qapi/machine.json
> @@ -1764,24 +1764,6 @@
>    'returns': 'HumanReadableText',
>    'features': [ 'unstable' ] }
>  
> -##
> -# @x-query-opcount:
> -#
> -# Query TCG opcode counters
> -#
> -# Features:
> -#
> -# @unstable: This command is meant for debugging.
> -#
> -# Returns: TCG opcode counters
> -#
> -# Since: 6.2
> -##
> -{ 'command': 'x-query-opcount',
> -  'returns': 'HumanReadableText',
> -  'if': 'CONFIG_TCG',
> -  'features': [ 'unstable' ] }
> -
>  ##
>  # @x-query-ramblock:
>  #
> diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
> index 1c182b6bfb5..7c686226b21 100644
> --- a/accel/tcg/monitor.c
> +++ b/accel/tcg/monitor.c
> @@ -215,30 +215,9 @@ HumanReadableText *qmp_x_query_jit(Error **errp)
>      return human_readable_text_from_str(buf);
>  }
>  
> -static void tcg_dump_op_count(GString *buf)
> -{
> -    g_string_append_printf(buf, "[TCG profiler not compiled]\n");
> -}
> -
> -HumanReadableText *qmp_x_query_opcount(Error **errp)
> -{
> -    g_autoptr(GString) buf = g_string_new("");
> -
> -    if (!tcg_enabled()) {
> -        error_setg(errp,
> -                   "Opcode count information is only available with accel=tcg");
> -        return NULL;
> -    }
> -
> -    tcg_dump_op_count(buf);
> -
> -    return human_readable_text_from_str(buf);
> -}
> -
>  static void hmp_tcg_register(void)
>  {
>      monitor_register_hmp_info_hrt("jit", qmp_x_query_jit);
> -    monitor_register_hmp_info_hrt("opcount", qmp_x_query_opcount);
>  }
>  
>  type_init(hmp_tcg_register);
> diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
> index 040d042810b..cf718761861 100644
> --- a/tests/qtest/qmp-cmd-test.c
> +++ b/tests/qtest/qmp-cmd-test.c
> @@ -51,7 +51,6 @@ static int query_error_class(const char *cmd)
>          { "x-query-usb", ERROR_CLASS_GENERIC_ERROR },
>          /* Only valid with accel=tcg */
>          { "x-query-jit", ERROR_CLASS_GENERIC_ERROR },
> -        { "x-query-opcount", ERROR_CLASS_GENERIC_ERROR },
>          { "xen-event-list", ERROR_CLASS_GENERIC_ERROR },
>          { NULL, -1 }
>      };
> diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
> index 639a450ee51..d7979222752 100644
> --- a/hmp-commands-info.hx
> +++ b/hmp-commands-info.hx
> @@ -256,20 +256,6 @@ SRST
>      Show dynamic compiler info.
>  ERST
>  
> -#if defined(CONFIG_TCG)
> -    {
> -        .name       = "opcount",
> -        .args_type  = "",
> -        .params     = "",
> -        .help       = "show dynamic compiler opcode counters",
> -    },
> -#endif
> -
> -SRST
> -  ``info opcount``
> -    Show dynamic compiler opcode counters
> -ERST
> -
>      {
>          .name       = "sync-profile",
>          .args_type  = "mean:-m,no_coalesce:-n,max:i?",
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

