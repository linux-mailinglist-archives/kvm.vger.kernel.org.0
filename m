Return-Path: <kvm+bounces-48420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C35A5ACE1AD
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 17:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91593A787B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 15:41:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 856D11A3168;
	Wed,  4 Jun 2025 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="MvpdE3Cp"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBE5146D6A;
	Wed,  4 Jun 2025 15:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051721; cv=none; b=K53DL7wL10StIAaUNLIBDP8nsx2I97xgdcRWwkuunuhmdWVuMtfpoyB4pIgv/K16IGXkKRew8sRDJUpCJdY7gNGhSQ9AdhQxdz7eOgspC0fRHWnKuf+8zN+6aN0oNkF11BZikOa/jtU8mhW0yQTd6Nzcd6yhQeKJfye8bb6H7T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051721; c=relaxed/simple;
	bh=rMc9LpBQ7NgcyLQMEUZqHc6toB/T5zpFVrloQqjog7U=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=fhl9/K6gSd9PKlp13x0v2eRagQc/JPjBSNI6WG1CVeqJgJo1SlVqtC0VHKJuZuSTCUcI+P8Vg4FMqaEoSCRBVpPpCd7s1gwp3x5u6SrGd5Qr+GAWZyi/I+9qtwMLJohZUW234gfFOMetjtvkQlGww4MA2GOvZcyr1hF8rZYXYJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=MvpdE3Cp; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [127.0.0.1] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 554FfQsf081940
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 4 Jun 2025 08:41:26 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 554FfQsf081940
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1749051687;
	bh=rMc9LpBQ7NgcyLQMEUZqHc6toB/T5zpFVrloQqjog7U=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=MvpdE3CpvzKYKJG3yH7XtkkMgROUTMYdw8rO3e4a+GYp38wzCHaQXsv+V65NwyTbg
	 I1bkU7lonjMsEhnQ2FSKdRTeufL/h0+k+fVPA++oSUGRrVlbwjR2VCOEqIAi6igqPH
	 90b9QcJGKNqwwS0n/L34JOLxR5V9PBfW2vzDTHUq5k/0nr1afIZslRcNOXRYp3uLw/
	 lCK8Pt0FYC1WpVkosr+ROs3Bnzz1nJPpgi95PueEyDeZBWDmxHb2CQf1TfNbqSVntN
	 e89wmhZPGzgDgK4shpHpImP78rUi5sKlgV578xuIv8irkIezm696S/zV6JhrI1DeWf
	 iMpEqK+q+CNcg==
Date: Wed, 04 Jun 2025 08:41:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Sohil Mehta <sohil.mehta@intel.com>, Xin Li <xin@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
CC: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jacob Pan <jacob.pan@linux.microsoft.com>,
        Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>,
        Sandipan Das <sandipan.das@amd.com>, linux-perf-users@vger.kernel.org,
        linux-edac@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6_9/9=5D_x86/nmi=3A_Print_source_inf?=
 =?US-ASCII?Q?ormation_with_the_unknown_NMI_console_message?=
User-Agent: K-9 Mail for Android
In-Reply-To: <fa948d41-3f95-4385-86c1-5c115561b939@intel.com>
References: <20250513203803.2636561-1-sohil.mehta@intel.com> <20250513203803.2636561-10-sohil.mehta@intel.com> <31507dc8-b1dc-4df3-bc0c-6958b4218746@zytor.com> <fa948d41-3f95-4385-86c1-5c115561b939@intel.com>
Message-ID: <8035D788-0F60-48B8-8B98-DC352EC9AE62@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

I think printing the bitmap is fine for unknown bits set=2E=2E=2E after all=
, you might have surprise vectors=2E Maybe a list would be cleaner by some =
definition, but we already print bitmaps all over the place=2E It is not cr=
itical as long as the information necessary for debugging is there=2E In fa=
ct, it is often better for the information to be compact so users don't get=
 tempted to abbreviate a bug report=2E

