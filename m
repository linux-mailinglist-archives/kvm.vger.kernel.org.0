Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AAC72E6C0
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 17:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbjFMPLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 11:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbjFMPLL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 11:11:11 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2078.outbound.protection.outlook.com [40.107.104.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649AA1734
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 08:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIPA1XMqfRB8e0hYGw9NXjuLUjzUjF/hoJYvecm3LVE=;
 b=4aY9XQrFedAhgIUZ36Fi0U5csmpuVttpJDEC9s0hotB1xrN6/yDYeE59S5XfdfrVLo2gbnjP2puFvfBx0PlzjmZFy6cVYdmWdg2OmXP+f4W9NcojsucOR8NWlj1bLjYqNodNs6vZyZFxZc09KCfjz1+DxEc54ySDqY4leiauk3g=
Received: from AS9PR06CA0173.eurprd06.prod.outlook.com (2603:10a6:20b:45c::7)
 by PAXPR08MB7393.eurprd08.prod.outlook.com (2603:10a6:102:2bd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 13 Jun
 2023 15:10:57 +0000
Received: from AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:45c:cafe::43) by AS9PR06CA0173.outlook.office365.com
 (2603:10a6:20b:45c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Tue, 13 Jun 2023 15:10:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM7EUR03FT023.mail.protection.outlook.com (100.127.140.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.23 via Frontend Transport; Tue, 13 Jun 2023 15:10:54 +0000
Received: ("Tessian outbound 5bb4c51d5a1f:v136"); Tue, 13 Jun 2023 15:10:54 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: edb2e63d90049da8
X-CR-MTA-TID: 64aa7808
Received: from 325d364791b6.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 83763F12-B74F-42E2-B97B-3F2F4A7D3B16.1;
        Tue, 13 Jun 2023 15:10:48 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 325d364791b6.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 13 Jun 2023 15:10:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToYwiAvnBZbLnn3ZtcWYuNkzVIISbbUwYFI05KbuAjktXLQB8EWVDabXfwCvIU8lnPXZf4NeSkOGQg85CrYY/SAX3Z6w5Z4B1z+Z1T5slpc+KAgdv4i7+VKdJGaVUmheqqEkJ/VrcudUbKqXFZDIpL5RhU1p+/HEhiLjjSSKiPl0zjw/xeMFl3AiDJ/aBZXA9MPe91Y/qTjreDyLh3ZMpbwvUimUb7A4YrA0h6LIEYdmgq+RHiGTuolCOGOP/Hpw81BYnYgin7ricbtxz0sQEZ+lRkFtWpDYOQ/7HDWWV+NxD+onx/bA2t2TCMHF/soh7Lnv/8M5p1GwEja0dntJBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rIPA1XMqfRB8e0hYGw9NXjuLUjzUjF/hoJYvecm3LVE=;
 b=E66JqnmRYMbgox0sRzeJWCQ+OOBsmPqoEOJGGFAmV0Aoc5bs2BmVzXWuT7E9XotTOuLQh/+2TV7Q9Bl90KfsjKdvKcl7mRw8RX8Q4/6bGc1PNQttbwDAVohX/EiO9xjId7xgv86utlRTmLVzTR41gArC4v4D8R9TUTBucjV5H5n+1uOMGba5qcpctvir/Mi49ssRSzaRQt8koukhTcFSDUsJ2vWtB86UvmwHTAyrTXOs0piVaJPy+A5q8SSNru+usvFRxoHpdvfNmFayKC18QKhnnQ7KwF/bRFtEdF7O3WDT1QFbUH0pgbuDQNbSI0g5b4b8J3ezGYB1QE3111lHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 40.67.248.234) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIPA1XMqfRB8e0hYGw9NXjuLUjzUjF/hoJYvecm3LVE=;
 b=4aY9XQrFedAhgIUZ36Fi0U5csmpuVttpJDEC9s0hotB1xrN6/yDYeE59S5XfdfrVLo2gbnjP2puFvfBx0PlzjmZFy6cVYdmWdg2OmXP+f4W9NcojsucOR8NWlj1bLjYqNodNs6vZyZFxZc09KCfjz1+DxEc54ySDqY4leiauk3g=
Received: from DB6PR0501CA0013.eurprd05.prod.outlook.com (2603:10a6:4:8f::23)
 by DB4PR08MB8198.eurprd08.prod.outlook.com (2603:10a6:10:382::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 15:10:44 +0000
Received: from DBAEUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:8f:cafe::df) by DB6PR0501CA0013.outlook.office365.com
 (2603:10a6:4:8f::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28 via Frontend
 Transport; Tue, 13 Jun 2023 15:10:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 40.67.248.234)
 smtp.mailfrom=arm.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 40.67.248.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=40.67.248.234; helo=nebula.arm.com; pr=C
Received: from nebula.arm.com (40.67.248.234) by
 DBAEUR03FT054.mail.protection.outlook.com (100.127.142.218) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6500.23 via Frontend Transport; Tue, 13 Jun 2023 15:10:44 +0000
Received: from AZ-NEU-EX03.Arm.com (10.251.24.31) by AZ-NEU-EX04.Arm.com
 (10.251.24.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 13 Jun
 2023 15:10:43 +0000
Received: from e124191.cambridge.arm.com (10.1.197.45) by mail.arm.com
 (10.251.24.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23 via Frontend
 Transport; Tue, 13 Jun 2023 15:10:43 +0000
Date:   Tue, 13 Jun 2023 16:10:41 +0100
From:   Joey Gouly <joey.gouly@arm.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Salil Mehta" <salil.mehta@huawei.com>, <nd@arm.com>
Subject: Re: [PATCH kvmtool 14/21] aarch64: Add skeleton implementation for
 PSCI
Message-ID: <20230613151041.GA2636717@e124191.cambridge.arm.com>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230526221712.317287-15-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230526221712.317287-15-oliver.upton@linux.dev>
X-EOPAttributedMessage: 1
X-MS-TrafficTypeDiagnostic: DBAEUR03FT054:EE_|DB4PR08MB8198:EE_|AM7EUR03FT023:EE_|PAXPR08MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ab4fbaa-f087-4453-a1fa-08db6c20627b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EuQUbMp2R2xTplraInoCQz+6OtozJky/DD326LRei+fWA8nKJXOIkxNbOwQVvrJuKw5ZfJjnK5YUCQyDfNBiJzne2wfM+1BKqONpybT2XklA+aMO3gRo3ZUtsOM+P9ASs12mqdwxasyq98aeJRSLSyS+KZIpYzthOZeJ7xxcYCUS/XR66LwOMFkxRsew5m9zoU57P7R31dT2Q0b7TWAwsAeGiFp/b6goszpmzNgg3UVLBr7vGUD6QW733D2cC7vzvsa7hijvO5cbr9lS4ev/kN6gtz4L0wNvRYCnL5OudqF8jtXIJpjxKKyfxSoYRk8XSOEk8sOeuY4IAw9eKqnPM2YDIGxZ2Q9ZCozaQrdGPWS8BLO3KlOu1NZldZq5JhnBZpSwvPbxLknPsmXWV0x3Pk04nPD0CAfTruY0YkuynAMmGqIuRtFboz0UkgHpxtdzbB0CqMUNf70gTwhxOSF19eBu6++exAAWI+WAPbZ/sJ2BN+cAl1hITQ4NF3dlTPH2zzKmcou1Vj/23eh/WoBCVjs/1E5JcJvLMioxvEO6d2XaVPgdiuiO0Ja3fTCHAlKo4sl+eYGimQJxK+aApK7fqUWmIpvhD3otAkeROTJVnvCVFcc6QwvRrF0tb3YCehbeELLLfWUrFPmaoacQ8wqTJTO/IGtqmfgmGFEI7QyLZotIt+F5YeYtoTf5sV3dJM2iV4ZiIL41oW4tZfiGj9ZLGAh+hXvoJrIs4DDcRBXkNcGUTIK+Z05vdee3F7hoPblq
X-Forefront-Antispam-Report-Untrusted: CIP:40.67.248.234;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:nebula.arm.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199021)(36840700001)(46966006)(5660300002)(8676002)(8936002)(2906002)(70206006)(70586007)(54906003)(44832011)(7696005)(4326008)(26005)(1076003)(41300700001)(316002)(6916009)(186003)(36860700001)(82740400003)(356005)(336012)(426003)(47076005)(83380400001)(478600001)(40480700001)(33656002)(86362001)(55016003)(82310400005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8198
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9fbf28f5-9bfd-420f-20d7-08db6c205c15
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GRf61bQGGzP0hrn3mv6B173Et7YICMIP8OlXorxI6zbCi9dTf1CioedvqkRDBcnuGooekHp1N1v1DBaQJAoJpKVoSJmYRaI1v/4s9wmC7hrEX3LgQObHjP5+Ln+ZQXE3wOQPZlKFpXOOFRd17LG/aqWRvi5A0HogE/E9aVB7WQ55IrSItyiAgdR1Z8Gcapi72/CgkSN5Ylzq/jwiMfAbWKzOny9rejp9hBC1w60bytIKPP9zi6KqwUGbLgyi7K3g6aSi2OrMvieSgQylEhMg7XqcugSaNUdr296L15wmvneVFpKz7/f3d8ig32PzrJapuB4CVUvalzd4nIiKfYu3yV+z7shoA2zhNBLdw+a3ZtMIaKj+cWFL8D9hnptwPqZIlH9v0U6jsGTZ+V6AtU76CXKTyjMzlsEmCB88vLkwyB7cPWgZ3ZsIYj1bDbHNSBeV0Vgr9CDrpK7feGQUfnsFknajaq+2bCmsDg1t8m5VZFRD91rN3d2aK161PdUnYI0YlOH5T163g1/NdG5M/Ar/JXVGCIoqSOTtidBXm9vLZQow8hwVV2pbKsjSrgZ1sPAwMoDbAtqYiRhNzJCQE3llvpKmxp+bn5Kz+c/JPKWxHNiwaKQAMQyYJrywIRm9hHeKINn4hKnCdL/nG2miFs0GpX2rqSM8i6NQ8mJcrLzmidmbRYBoOaVSzsjImTHBN64BPUnAjDizjjrmnpUZGIkHmXKxpaY3SjlOZRl9BKgaCdylPbB61sUPLFuk2oxbYjvL
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(46966006)(36840700001)(40470700004)(316002)(7696005)(41300700001)(426003)(82310400005)(86362001)(83380400001)(47076005)(26005)(44832011)(186003)(1076003)(33656002)(2906002)(81166007)(40480700001)(55016003)(36860700001)(82740400003)(40460700003)(336012)(8936002)(5660300002)(8676002)(6862004)(70586007)(70206006)(478600001)(54906003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:10:54.9455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab4fbaa-f087-4453-a1fa-08db6c20627b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM7EUR03FT023.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7393
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Fri, May 26, 2023 at 10:17:05PM +0000, Oliver Upton wrote:
> Add an extremely barebones implementation for handling PSCI, where the
> only supported call is PSCI_VERSION.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Makefile                        |  4 +-
>  arm/aarch32/kvm-cpu.c           |  5 +++
>  arm/aarch64/include/asm/smccc.h | 65 +++++++++++++++++++++++++++++++++
>  arm/aarch64/kvm-cpu.c           | 14 +++++++
>  arm/aarch64/kvm.c               |  2 +
>  arm/aarch64/psci.c              | 36 ++++++++++++++++++
>  arm/aarch64/smccc.c             | 45 +++++++++++++++++++++++
>  arm/kvm-cpu.c                   |  5 ---
>  8 files changed, 170 insertions(+), 6 deletions(-)
>  create mode 100644 arm/aarch64/include/asm/smccc.h
>  create mode 100644 arm/aarch64/psci.c
>  create mode 100644 arm/aarch64/smccc.c
> 
> diff --git a/Makefile b/Makefile
> index ed2414bd8d1a..fa4836aebc5e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -190,8 +190,10 @@ ifeq ($(ARCH), arm64)
>  	OBJS		+= arm/aarch64/arm-cpu.o
>  	OBJS		+= arm/aarch64/kvm-cpu.o
>  	OBJS		+= arm/aarch64/kvm.o
> -	OBJS		+= arm/aarch64/pvtime.o
>  	OBJS		+= arm/aarch64/pmu.o
> +	OBJS		+= arm/aarch64/psci.o
> +	OBJS		+= arm/aarch64/pvtime.o
> +	OBJS		+= arm/aarch64/smccc.o
>  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>  
> diff --git a/arm/aarch32/kvm-cpu.c b/arm/aarch32/kvm-cpu.c
> index 95fb1da5ba3d..1063b9e5b6a9 100644
> --- a/arm/aarch32/kvm-cpu.c
> +++ b/arm/aarch32/kvm-cpu.c
> @@ -130,3 +130,8 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
>  		die("KVM_GET_ONE_REG failed (LR_svc)");
>  	dprintf(debug_fd, " LR_svc:  0x%x\n", data);
>  }
> +
> +bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> +{
> +	return false;
> +}
> diff --git a/arm/aarch64/include/asm/smccc.h b/arm/aarch64/include/asm/smccc.h
> new file mode 100644
> index 000000000000..c1be21a7d6f6
> --- /dev/null
> +++ b/arm/aarch64/include/asm/smccc.h
> @@ -0,0 +1,65 @@
> +#ifndef __ARM_SMCCC_H__
> +#define __ARM_SMCCC_H__
> +
> +#include "kvm/kvm-cpu.h"
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/types.h>
> +
> +static inline bool smccc_is_64bit(struct kvm_cpu *vcpu)
> +{
> +	return ARM_SMCCC_IS_64(vcpu->kvm_run->hypercall.nr);
> +}
> +
> +static inline bool smccc_calling_conv_allowed(struct kvm_cpu *vcpu, u32 fn)
> +{
> +	return !(vcpu->kvm->cfg.arch.aarch32_guest && ARM_SMCCC_IS_64(fn));
> +}
> +
> +static inline u64 smccc_get_arg(struct kvm_cpu *vcpu, u8 arg)
> +{
> +	u64 val;
> +	struct kvm_one_reg reg = {
> +		.id	= ARM64_CORE_REG(regs.regs[arg]),
> +		.addr	= (u64)&val,
> +	};
> +
> +	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg))
> +		die_perror("KVM_GET_ONE_REG failed");
> +
> +	if (!smccc_is_64bit(vcpu))
> +		val = (u32)val;
> +
> +	return val;
> +}
> +
> +static inline void smccc_return_result(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
> +{
> +	unsigned long *vals = (unsigned long *)res;
> +	unsigned long i;
> +
> +	/*
> +	 * The author was lazy and chose to abuse the layout of struct
> +	 * arm_smccc_res to write a loop set the retvals.
> +	 */
> +	for (i = 0; i < sizeof(*res) / sizeof(unsigned long); i++) {
> +		u64 val = vals[i];
> +		struct kvm_one_reg reg = {
> +			.id	= ARM64_CORE_REG(regs.regs[i]),
> +			.addr	= (u64)&val,
> +		};
> +
> +		if (!smccc_is_64bit(vcpu))
> +			val = (u32)val;
> +
> +		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg))
> +			die_perror("KVM_SET_ONE_REG failed");
> +	}
> +}
> +
> +bool handle_hypercall(struct kvm_cpu *vcpu);
> +void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res);
> +
> +void kvm__setup_smccc(struct kvm *kvm);
> +
> +#endif /* __ARM_SMCCC_H__ */
> diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
> index 1e5a6cfdaf40..4feed9f41cb0 100644
> --- a/arm/aarch64/kvm-cpu.c
> +++ b/arm/aarch64/kvm-cpu.c
> @@ -1,3 +1,4 @@
> +#include "asm/smccc.h"
>  #include "kvm/kvm-cpu.h"
>  #include "kvm/kvm.h"
>  #include "kvm/virtio.h"
> @@ -261,3 +262,16 @@ void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
>  		die("KVM_GET_ONE_REG failed (lr)");
>  	dprintf(debug_fd, " LR:    0x%lx\n", data);
>  }
> +
> +bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> +{
> +	struct kvm_run *run = vcpu->kvm_run;
> +
> +	switch (run->exit_reason) {
> +	case KVM_EXIT_HYPERCALL:
> +		handle_hypercall(vcpu);
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 4929ce48843b..ce917ed01349 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -1,3 +1,4 @@
> +#include "asm/smccc.h"
>  #include "kvm/kvm.h"
>  #include "kvm/kvm-cpu.h"
>  
> @@ -165,6 +166,7 @@ static void kvm__arch_enable_mte(struct kvm *kvm)
>  void __kvm__arm_init(struct kvm *kvm)
>  {
>  	kvm__arch_enable_mte(kvm);
> +	kvm__setup_smccc(kvm);
>  }
>  
>  struct kvm_cpu *kvm__arch_mpidr_to_vcpu(struct kvm *kvm, u64 target_mpidr)
> diff --git a/arm/aarch64/psci.c b/arm/aarch64/psci.c
> new file mode 100644
> index 000000000000..482b9a7442c6
> --- /dev/null
> +++ b/arm/aarch64/psci.c
> @@ -0,0 +1,36 @@
> +#include "asm/smccc.h"
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/util.h"
> +
> +#include <linux/psci.h>
> +#include <linux/types.h>
> +
> +static void psci_features(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
> +{
> +	u32 arg = smccc_get_arg(vcpu, 1);
> +
> +	res->a0 = PSCI_RET_NOT_SUPPORTED;
> +	if (!smccc_calling_conv_allowed(vcpu, arg))
> +		return;
> +
> +	switch (arg) {
> +	case ARM_SMCCC_VERSION_FUNC_ID:
> +		res->a0 = PSCI_RET_SUCCESS;
> +		break;
> +	}
> +}
> +
> +void handle_psci(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
> +{
> +	switch (vcpu->kvm_run->hypercall.nr) {
> +	case PSCI_0_2_FN_PSCI_VERSION:
> +		res->a0 = PSCI_VERSION(1, 0);
> +		break;
> +	case PSCI_1_0_FN_PSCI_FEATURES:
> +		psci_features(vcpu, res);
> +		break;
> +	default:
> +		res->a0 = PSCI_RET_NOT_SUPPORTED;
> +	}
> +}
> diff --git a/arm/aarch64/smccc.c b/arm/aarch64/smccc.c
> new file mode 100644
> index 000000000000..b95077305ffa
> --- /dev/null
> +++ b/arm/aarch64/smccc.c
> @@ -0,0 +1,45 @@
> +#include "asm/smccc.h"
> +#include "kvm/kvm.h"
> +#include "kvm/kvm-cpu.h"
> +#include "kvm/util.h"
> +
> +#include <linux/types.h>
> +
> +static void handle_std_call(struct kvm_cpu *vcpu, struct arm_smccc_res *res)
> +{
> +	u32 fn = vcpu->kvm_run->hypercall.nr;
> +
> +	switch (ARM_SMCCC_FUNC_NUM(fn)) {
> +	/* PSCI */
> +	case 0x00 ... 0x1F:
> +		handle_psci(vcpu, res);
> +		break;
> +	}
> +}
> +
> +bool handle_hypercall(struct kvm_cpu *vcpu)
> +{
> +	u32 fn = vcpu->kvm_run->hypercall.nr;
> +	struct arm_smccc_res res = {
> +		.a0	= SMCCC_RET_NOT_SUPPORTED,
> +	};
> +
> +	if (!smccc_calling_conv_allowed(vcpu, fn))
> +		goto out;
> +
> +	switch (ARM_SMCCC_OWNER_NUM(fn)) {
> +	case ARM_SMCCC_OWNER_STANDARD:
> +		handle_std_call(vcpu, &res);
> +		break;
> +	default:

I get the following error while compiling (adding a `break;` fixes things):

	arm/aarch64/smccc.c: In function 'handle_hypercall':
	arm/aarch64/smccc.c:34:2: error: label at end of compound statement
	   34 |  default:
	      |  ^~~~~~~

> +	}
> +
> +out:
> +	smccc_return_result(vcpu, &res);
> +	return true;
> +}
> +
> +void kvm__setup_smccc(struct kvm *kvm)
> +{
> +
> +}
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 12a366b9b38b..3e383065ddaa 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -158,11 +158,6 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
>  	free(vcpu);
>  }
>  
> -bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> -{
> -	return false;
> -}
> -
>  void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
>  {
>  }

Thanks,
Joey
