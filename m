Return-Path: <kvm+bounces-10756-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE26E86FA9D
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 08:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16B111C20D83
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 07:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE9EA134AD;
	Mon,  4 Mar 2024 07:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="HjvASZJZ";
	dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b="HjvASZJZ"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2043.outbound.protection.outlook.com [40.107.22.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E0D13AF3
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 07:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709536862; cv=fail; b=N9bpx4YYO0lCRUDs3s+0OAoq/myAZvYuTGxPhXd47FSpLHjF4Tv8ES4zYWVOV5xL/qp9WfcjoElDJc9x48g9hPfRoJ5cQwBIf/4Z7XTubzL18odm3zB213TygucdxONuHSh+r8KVfeoMXhNnpqwfSbOs6B94j6VT8Jz4OebY/0g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709536862; c=relaxed/simple;
	bh=WPoTwCTsFjn34trcRlzGCnCPBYVZ51ZL+HFFEWfGSug=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WZtk8EymDyd8bWML272RWrc104Pcvtfl7AQ656arXAy2MgGTp8h1BhHei3/s16VY4ChTfr1PHg3mvZ/znSnRzfe0lsqDXK65aIP/2rg/nNt6PDuvAtIPw2w/hdHLm1NFHVo00KIemh70h3L0JemkFWpqKxzV49MuVu3zSUQ1leE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=HjvASZJZ; dkim=pass (1024-bit key) header.d=armh.onmicrosoft.com header.i=@armh.onmicrosoft.com header.b=HjvASZJZ; arc=fail smtp.client-ip=40.107.22.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=pass;
 b=kHrb89XMUxEPDxEIZdDPqw3zn4YFiqqBqWnoYcagsW1XHxeell2hevlomBqgIAgvTuHdIWSB5Ytv356mNrEubR6oj437ZljPHX5bFpgYUIczAhcCKyBocf0Nq2FV2GjbMbh+LsiEbp6Fm34w5ug5kg5E1xdEr4/r9ducWNoIOa5K4lBXXPV7bavtH8F4r5KNCT0fESyowZbeXF6mgoR/mMpltt0EYUT7BtenASJP4RNpR5uLctcGzDNp70t9ioes0kkY+Iv7ojFM1QLDcINRjI5DVoYX3ylwAxJy0iM5npEhUgzBFLt5I1QodkQcTWuFNVMG1T215FzAN/eJCLJ6pQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=fQL2YD4wrXDtjbbY2uuVT/19MPBKvq+uhqNJJCeGyjc/HRBFUst/CYAP4ex8am4/YCzb+1VgJWa+GbSwfWzdGIjHi2BFuCdEaWZo9RvyicoVIvm4fH1QAUo6cZIsbNmngU/mvPiJHZrtFn/eXGPoIcwkg9mJg9Ms1jc4iM+89kQ3FBnMXu6quS7VI8fgF8AA4yP68qT6IjbJ2AzdolgbGpW77e0uzrsmdLiIHM9VaGpiqabuwN1DHRIvCl2xhZgpiucGXqs5EFyL6WV9pgVOZniq8RFp88JtPSUDuBVE9gLDKcyWicn0Z3sBiY7NTOH6B0IU3Qe46MBd/o3DAt/yVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=armh.onmicrosoft.com; arc=pass (0
 oda=1 ltdi=1 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=HjvASZJZQO6lmzj1ziLdcjykN0jwIfjBbtnekwSqhmMoIjSko97Ejtc2YrAS0gglsCTDMYYZTZ0oCz3DVJNOag4mGBvX58OCoe+vAh8GluN/8xKs/L1OztUk009XVI0Lv6048xxV48dKqPFIDX+gS7h/Q5vbuytiz+E6J17EDxY=
Received: from AS9PR06CA0005.eurprd06.prod.outlook.com (2603:10a6:20b:462::26)
 by PAWPR08MB8888.eurprd08.prod.outlook.com (2603:10a6:102:33c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 07:20:51 +0000
Received: from AMS0EPF000001B7.eurprd05.prod.outlook.com
 (2603:10a6:20b:462:cafe::9e) by AS9PR06CA0005.outlook.office365.com
 (2603:10a6:20b:462::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38 via Frontend
 Transport; Mon, 4 Mar 2024 07:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001B7.mail.protection.outlook.com (10.167.16.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.11 via Frontend Transport; Mon, 4 Mar 2024 07:20:51 +0000
Received: ("Tessian outbound c21fe6ca13cc:v228"); Mon, 04 Mar 2024 07:20:51 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ff437af2a78c815b
X-CR-MTA-TID: 64aa7808
Received: from 2ac324b2b3ed.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id BE27D57C-7BC7-4A90-BF4A-134A48B12624.1;
	Mon, 04 Mar 2024 07:20:40 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2ac324b2b3ed.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 04 Mar 2024 07:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6KOYXmJ+9c2QA+IcbA1bvsu/Zy6GDIk7N22K26MhpZT5Vrd8d4XOd7iO4ZjSUBXdEdJqIyVgWvNLSAs97PXaSZdzapBC9Mk+IGbK0DiEqgB0XViGgXNWPLqlcGzJX3+QPPgx/VfmQJ+uiooKr+Mo2+/pTYc2bN4sIHYrRog1inf+lZICC19OFWWs4YiUCV1axJtgco9jE95Ohq0nXAfmpYogW+eUhfqyssl+vEQKWDHuI1g4sIBnw54oJn9c+ogvwsqo9KgTWBcRm141IFze9Znu8vqxhX2y8mDgH6aRUfpGy4MBKP9sFL2tRbBf+nC0ymGGzWZbn+IVbsdpP3m3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=YwJPrA7QAGtIYXlmG9Q7IiMQXaF0al5etgG54G04tw7Y+1Z3ZUU9Cn/0ELPCFET0VsrMy3iMhdk21vi6wKS+LlwSMvVnnjHF8IxSMg7YIZAq2Pe8EnDi3fYznJx+V+HaHiO0tJoYRAYv0Tl5hXjwWVmzWPIL7AbDRU4AWQu6qJEySdCGpl3q2yT1Jvo/JwSM3wy5iE1ZPmaYhfjPBRNMnhmrEqS2Z53lFCtme/WgPdx0ePbHMWtqOzLnEg1t9cKYwEuhMJ336D/ADD27OO9+VDp/KUxjtngSkeyUpbKj05d/LTTNJJtdQFn6CfT6AclQkwdbANyoxTTv6XTsMJeJlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXSuWdxB59W2qJeUV8a5Nw0drObG4+zwNZc8Vl76kwY=;
 b=HjvASZJZQO6lmzj1ziLdcjykN0jwIfjBbtnekwSqhmMoIjSko97Ejtc2YrAS0gglsCTDMYYZTZ0oCz3DVJNOag4mGBvX58OCoe+vAh8GluN/8xKs/L1OztUk009XVI0Lv6048xxV48dKqPFIDX+gS7h/Q5vbuytiz+E6J17EDxY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com (2603:10a6:102:1df::21)
 by DU2PR08MB10085.eurprd08.prod.outlook.com (2603:10a6:10:496::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 07:20:37 +0000
Received: from PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd]) by PAXPR08MB7017.eurprd08.prod.outlook.com
 ([fe80::ff7d:ae5d:bc51:66fd%4]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 07:20:36 +0000
Message-ID: <92be0466-eb29-40f5-8313-d1b6326a6727@arm.com>
Date: Mon, 4 Mar 2024 07:20:35 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 07/18] arm64: efi: Remove EFI_USE_DTB
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com, eric.auger@redhat.com, shahuang@redhat.com,
 pbonzini@redhat.com, thuth@redhat.com
References: <20240227192109.487402-20-andrew.jones@linux.dev>
 <20240227192109.487402-27-andrew.jones@linux.dev>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20240227192109.487402-27-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO4P123CA0538.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::8) To PAXPR08MB7017.eurprd08.prod.outlook.com
 (2603:10a6:102:1df::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAXPR08MB7017:EE_|DU2PR08MB10085:EE_|AMS0EPF000001B7:EE_|PAWPR08MB8888:EE_
X-MS-Office365-Filtering-Correlation-Id: a1f05e1d-c06b-44a8-2111-08dc3c1b9f7d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 95xpR97vKEMUz+XBqbiCDIoD+LIUvtp3dq/IZwGT0wwRAYe0mSw2x10pPu1WCjNyR0mf+bLW7WYbCt+iQRj5V/QlOuqsfc1ihKrvYX4LP82hRsJdyjm2DpotJDulNz9TNcFu9nAbz+x/ltjxZ0uZIzWqsgIm2CXK7QO6KgTJb+1gQWmS4s6zCO9ekQmF8gYqUslRh+yarodLPOUpH2kj3O+V8k2yELk5ARR58CH+S1vOHOQa/EMUN4IxSHBtwKoQpxzP4larW1zW1JXt2YpPm4W3UIR8TpqPkc+UEPav5m0Dv9ZCaI98eY2RwSrFxM6vqpsKAP4DfPeSWfRqjQeYvwSFM0uabyR3zjfoJ4Y1Xsqqy/xVKxk7ssp+FCyMj2RYhctn3JWTrLSmhBbPEpV6ASP9CDM716J1tgsAbK+sZW0JHvhZNhl1KXHlfpPnkorVhxbEPDxjPsLR1cqGuGKuzzDsVpKWOWMaOJiPd23xnBBxAB1YAvn2xLdzna9UeZIy9l/Nxr4PJD2yncHFLnvoHkggTntfp+z+7sY/tgJOv22eBTuaouLGTV+skuNWjuShWm96uqVgB6gN90V/uzE1iabDyWJSZsnZ50yLA28OVe539YLYyWHNyN7On9faM86SL9CVlQUu9YsYokoFjVWNenmmWbYf/1HFupoYFP0q+DA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB7017.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10085
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	60c2096f-9754-4b2d-67d4-08dc3c1b965c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cL1w4M+RJeOtqvcbB1EsYspIkJYBTwGEhIrYyfWbZFx+BBpHtNvNKcB+w34Cg9zfynr98n3nI/PLbi7FokJx2XsXfu/7FofUw/6WA+taSvRXO9xT5f2901A1f8kaj/4LAXHhhjjaQzMo9Feq1nRh9m3Q2F0uITDmhDtrEWf+I7eEkBPQztd6rpdudA5Ffq09tJJfWx6ywFqPkTC1VxpEcxQYG4sUAyW+WKhYvTSVMl31oE0b3zcWURXQ/aw2DU6F40iHA9XLZ4jekwE19Hb0UEX3WbEBbGRZp/salsfAv4BxtSFDOxOQVxa1ZEIyv2ptlCcmvIxSUaag0MF05CLTE7fMo9jej+t49rCkfFX7bJYvnahflBYUaqlZQbyLKdjuS/1AsXf+3PSmDqkX56vX0zUnrnfkHsyRuWHAOZOdQCPqBozEy5dmHzvol9ng02/T2PVjvCKRFVF/GImZ/pKvZzmciEx9W62wCWZ5R6m6ETPxRmhc4jYuryYEl0h0FrGEmkZ9XC6T44oAdzco5slGPN4FljW8D99F26fhygx4UD0hJZccJU0o0AYDs3kHMkZeGdEvMcms3N5NCoVoC7hgNNLR+BL6flHvIqpj2gXXFH2Mj9l8CPQ/41mY3lnWWT3aJG1RStlhQxEd9u4G3cFHIqUb1yi2H6iN4RP+ixpT00ODrUHpJ2EENY9G0Z2gjOKO4hVXXf3PYejA1uE9H4HGh6Polv8UGkydGQG3nj31qdfwqT0lE6ttkduoLuxg09W+
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 07:20:51.6704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f05e1d-c06b-44a8-2111-08dc3c1b9f7d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8888

On 27/02/2024 19:21, Andrew Jones wrote:
> We don't need two variables for one boolean property. Just use
> !EFI_USE_ACPI to infer efi-use-dtb.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> ---
>   arm/efi/run | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arm/efi/run b/arm/efi/run
> index 494ba9e7efe7..b7a8418a07f8 100755
> --- a/arm/efi/run
> +++ b/arm/efi/run
> @@ -27,8 +27,6 @@ fi
>   : "${EFI_CASE_DIR:=3D"$EFI_TEST/$EFI_TESTNAME"}"
>   : "${EFI_VAR_GUID:=3D97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
>
> -[ "$EFI_USE_ACPI" =3D "y" ] || EFI_USE_DTB=3Dy
> -
>   if [ ! -f "$EFI_UEFI" ]; then
>       echo "UEFI firmware not found."
>       echo "Please specify the path with the env variable EFI_UEFI"
> @@ -68,7 +66,7 @@ uefi_shell_run()
>       mkdir -p "$EFI_CASE_DIR"
>       cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
>       echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
> -     if [ "$EFI_USE_DTB" =3D "y" ]; then
> +     if [ "$EFI_USE_ACPI" !=3D "y" ]; then
>               qemu_args+=3D(-machine acpi=3Doff)
>               FDT_BASENAME=3D"dtb"
>               UEFI_SHELL_RUN=3Dy $TEST_DIR/run -machine dumpdtb=3D"$EFI_C=
ASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

