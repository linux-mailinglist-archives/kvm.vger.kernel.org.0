Return-Path: <kvm+bounces-24385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9A695492F
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 14:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 567A8B2250C
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 12:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21F401AED29;
	Fri, 16 Aug 2024 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IYXxU40h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC94E1741D2
	for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 12:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723812859; cv=fail; b=AHzBQfftGKxfZTuVsZ9WgSKMVSOkGmfKzy7O9m3vZyTXKf/D0g4Ofpz9kiQcTNPGrcv/fh+mZmU4XYosKzWzDME1qB87u39m6BAfnbjjZ8urXOBHiZDRYQ5jiG5RLG83LfDdzXD5IQXDlDDhWxSuDCVdxj9DADn2NkqQWNH2e7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723812859; c=relaxed/simple;
	bh=kJ6AkNmxm3vje6wKPVq058mysPuYv2fnbo5+YQkNcb8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t9IL9Mhgpl4D/S9zwwyLQtHaOGQE5rdzJmayfS5E0DX03VaOM4whnpnKyyD/6duQqMZQUlWQQDmx79egJ9W1bvjx78l2xz9SxnLLHQ0V732Qhxdt96qmixeEWpCu81bKjuQePkt3TK9/XGXCnblU/1peld+Lo2H0bGKnUmLjtfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IYXxU40h; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kwOvFiaIj04mu12FCx6I33piLSxxDeRcQX5MtP0AlqO53IQMx+bWKe50FAXj7SBF9pP4L0FhuCRPdOpcvoAwHF/etRhbV8+xXK2CpjU3YF8cCfxkQPV3lKw10kQU5hhWxoMEhlLSxcHE0jxEU8Ef3mSi4iyEN5RkkoyhD5XpxX5+Fi6i1xfkUG6L391H+1RdXfxJpGdPW3lweGHmFxLagCjrOA9XWlslIau2EqLQDRs1tPjbEEh8+WqjPIvaVR1woy1fCWzoaqDzylzMlShikE8vrVowFWfClPW4P4TwxdnNRBLUOvtqC1vh3FDLHeqChfT4+Gt5r4hX1cLzSoW5QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5YgJf81HD4yHOlhITkRMcGah8InPT0bagFczX48mbs=;
 b=bPIr+4WqlgjQadOdronLfbxSoDcloJSi/1yfv1Iq2fPjc0+qH97RdEvEIiKn1lwSAH5qStBSM2R4KnDAsmufFEXBMn3v6DsroX0Y23HVKmlhcvNbseR+UiKAhFREeEEextakCMzlaNZQaOeXWgz0SBzzgpvwjjz1e67YJHw+R1Vseo/przRbZF5RlUsReKvsulUkfzqPcgJNkMWBStNwRo3V/YX2Oedy4yfO/RWUIQzAe611aD0HLDKXxOQQMXCqb8qWWD2sHK5toMziH+AMjad1Ts0B94r9cT9u3JNxtCw1cHTKPpAE4mfyDYxdfBTPeIo0yuNnj4QG8WMS+NAq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5YgJf81HD4yHOlhITkRMcGah8InPT0bagFczX48mbs=;
 b=IYXxU40h8DvC/Y4ECkWPzyaTCRCQzOFN23nPKEijx6s8XCX5pZ48m/SY/9X4WAxDpkti1psxUrDiUOnEAlXJ5ubq0Z17eSWlk0Kq4VPpCAv0nnsxGqVwx9MVcBTXZazLpdoGI0PKjvEV4KjUBueFtxkN18U5EXSB1hywe4FqbUpi5eiQ600FbWk77TBaSqbnRgEBwxDbhRNnYr1GZ5c96uHpCanSzF0nolMQbJFFa1AOmXrG0m/eLAU3k+z6WiR4YRCfCyiGB80owtnKutiahJ9a0vRxM5Mn6mdZxSZpyg7U1YHNEAEjarbxlhW5t+AnGOD8lkfixYKp/txiS2811w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA0PR12MB4398.namprd12.prod.outlook.com (2603:10b6:806:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Fri, 16 Aug
 2024 12:54:14 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Fri, 16 Aug 2024
 12:54:14 +0000
Date: Fri, 16 Aug 2024 09:52:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: Yi Liu <yi.l.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240816125252.GA2032816@nvidia.com>
References: <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f5bfba2-c1e7-4923-aa9c-59d76ccc4390@intel.com>
 <20240814144031.GO2032816@nvidia.com>
 <b37a7336-36af-4ffc-a50f-c9b578cd9bda@intel.com>
 <6f293363-1c02-4389-a6b3-7e9845b0f251@amd.com>
 <8a73ef9c-bd37-403f-abdf-b00e8eb45236@intel.com>
 <f6c4e06e-e946-489f-8856-f18e1c1cc0aa@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6c4e06e-e946-489f-8856-f18e1c1cc0aa@amd.com>
X-ClientProxiedBy: BN9P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::30) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA0PR12MB4398:EE_
X-MS-Office365-Filtering-Correlation-Id: eb1deb3b-6d94-4ebc-59ab-08dcbdf28813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?28ENR/g1Yuq+I7ft05r135icMfVE9HXcWmi3qQZMV2YbEgrIGLlyn81yIqrR?=
 =?us-ascii?Q?BGogzuu7eCL3x2bSnydSABVIwGXjAb4V0+HhKip8NfrLF6+kHAhQbPITuJCT?=
 =?us-ascii?Q?UDraXo01mNZcVRhq3nQhkJbI0oD9asbSJqr5402aqA0RvQ6ydZXxGanJ/1vD?=
 =?us-ascii?Q?2iKpMNCELnO0Sqz3oug1QUOFKvtwlOnfI7p44HJ7uMvOmieoJ2c6hUw53g3a?=
 =?us-ascii?Q?9eQh1RG8QAshXi44LgDeoRsW8S9DBRJntKf0MkFRYN42+2oJus6vVZDvzjek?=
 =?us-ascii?Q?X9WNjFetUSbyVhOtHy5Siaxa9WY67BXcXN6rmL38vLM/1PLhq4uRC1GVq3PD?=
 =?us-ascii?Q?E8fPUZElF7XIi5mMNesdn75PMf+/zydAoPMAL132tAo9G8a+DeWpLGxp8Hy4?=
 =?us-ascii?Q?NTm/spKprAQtuwNDOWj3i5fhvQPV/Dh4P38DC3Fg31NtzT7KduYyt24vMzOV?=
 =?us-ascii?Q?GAZ1cr1wTvvL9PhC9AbHgsaUGeHgHwUo3u/tdVY+MorJU+70UXYGgzSonTb2?=
 =?us-ascii?Q?XkC16/Fwx0XybxGyvAZ1FxxEW3qx05oTFpcqUGZi94Hb13huBDwE72lHDxhC?=
 =?us-ascii?Q?2bKCZO3HIGfdp8O5dtJVioi7YrhhHBrtT2S3nSJWQD7cdPqkaRMyTK7PEZuj?=
 =?us-ascii?Q?UULQY5NQq8fPCCJyuR3X7DwuT1RXpdL6Q1T3sK6e7QW0LkX0Y3XU7wjtc3yz?=
 =?us-ascii?Q?d02/QyOdlTMZgNsTyPPMy5wbZyYDi9CHNGzbQLwyDNbum+ZjGZ9FTOgezxOq?=
 =?us-ascii?Q?4KtJhRdHZrDiYsIfsgqlnW10spx+91gcPCGZP0m7BmZ0x6bd34R8NaXxrYJN?=
 =?us-ascii?Q?yIj91QnCVIjvFsWLqHZzI/pfdOBiyZ7qeh055YUFdm47vFp6Kac53mp4VwOA?=
 =?us-ascii?Q?1Dt/QRh0zlCzp6iJy7ApVoG5ddc0fAtTPX/I7TaJCynqoijQMQoq6K+PK54W?=
 =?us-ascii?Q?2vktltJf5XtpDZeSKan1PRW2CM2YdBWC3rddgWpdim04cz3YQJMsvIZXvdNq?=
 =?us-ascii?Q?3n9yVt53RKMVQyUYAChVIa0RzUn4BnyZ/OGDw5DpRQf/MY6H9cCluP484VAi?=
 =?us-ascii?Q?1xkiBXWKCMTaYvPKumTJzCWP6gzjpAU6W6yw2J1Tf31we9MKieB3HyrJeeuT?=
 =?us-ascii?Q?xYoNCxDpx56oxD1FkDNb6ZBCJn698KP7wmiQATgsiPOsgafUPsdMj8pWp6Zl?=
 =?us-ascii?Q?syeIBw6gXVMUWJlILm8wmtCOyLB92Ab5Um4wXsJMVgG8ogqKN6BAOt4PWYxo?=
 =?us-ascii?Q?LQWxiuyTUsdV56crhE5Ca4nu3eIQKN+7yvqyTw+Us/d7YciOQNrN4+cMjZPR?=
 =?us-ascii?Q?0UBM8wskABDj87WTdMO5poq/kiVE8w62SPKJagFyAJRyhA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PmKX5UFdGWoZknyzEb/nkVzFSrtkJVKnSpZkhlgc3b4EOrDii2f/QfAhpwNl?=
 =?us-ascii?Q?bo3kfJy9z8L+v5KZRNLiSf5lH2w91uycLrlYNYW7+Bs7eSw9r9a7tCnxeVXe?=
 =?us-ascii?Q?VOu2qOYDbMwmgXCQb//j3X4ROXQR9pZxMvoJpnzte0iJrHUjcHuflG6pSK8L?=
 =?us-ascii?Q?Q6jEL+lYtX8m3BbjpTLTPFHIXezQ0Rlk/82a544RW59snmgDBRzir6r7WPlu?=
 =?us-ascii?Q?w7+uxWfHIIRjeNZCbHLwfAUPxoeSuE8q53S+agxFK4PB3A5HjcZdsoi/mTPD?=
 =?us-ascii?Q?Jif16F09IjNb4PF55P80cWrz+kWrDQdV/xeQDwG7pDyp1uF7G297qZG2tvYn?=
 =?us-ascii?Q?Z9Q5VxAQIxrzA0AXSPnEsnJWgq2VWrCEfNKPbbGMBkTl/9LdAdeGwofWdsRR?=
 =?us-ascii?Q?+sjiqqAzdBZdPXJHMhxcwd7KRFWQH2CVZeA2Byu8IzmlmSixpyue8C0TR32O?=
 =?us-ascii?Q?hpgSVpRGhT/knvI5/0Zgnt8UoysEgAWFS+nwY1wc/TGLLZKOwjjNmsAb0HZN?=
 =?us-ascii?Q?elyrnVqs7dtRb3d2edGybsXK/XVxAX1PzcqqMBm6cQ4ZU4fiUKpdwwGd1Coq?=
 =?us-ascii?Q?bewCorbyPJrjHZhNF+9OO9MN3I9oz/1LFBRcEMZzpzWwqz/tmnzQT3PSVL1B?=
 =?us-ascii?Q?axI31PSZ24vapd4o6xcAOPbEHyq+jPEgMnJDqvgn7vp4WjC6Dv7la0FSdDZJ?=
 =?us-ascii?Q?1B5TFiTBe+q3R968IxosrI1ESQOjm1xyu0ERpd7H/mcjllKaXxIMkbwXHozC?=
 =?us-ascii?Q?dGn90sBbsGwwsxWYMEgu7vZYlUSF8kBtR7S5y+mSSbzOjg1EcbT3q7B+bna3?=
 =?us-ascii?Q?NbXIMG8+IMUCpuSVPyJgGZnD6UmiEIapp0lAv2wF/qUOqyWoAT7EyYxgy773?=
 =?us-ascii?Q?vSsLBX55zKct9nenmT/Vecr9+Gm54f/GBvsgPN3OLxd7ABItvwiVMWwZCAhG?=
 =?us-ascii?Q?FNBhWDlNiqf8FZVvfYGmLSElO0WLg61tw/ne65YJquLuEV7Zj+pDn/l8RPbF?=
 =?us-ascii?Q?NvmMDLUbMcLglVIZHG5u2v4Au1kolPhnROf5QEFYzKyNdyTlmt2GFwK6/M5O?=
 =?us-ascii?Q?QyIr2n555leV3eswhLvWZdy56v1peiS+1s/NkXK15aB1NybdYv5UO73NG8rf?=
 =?us-ascii?Q?3qdmJVPmJI4cLXDuTL0QDV7ttlsRIz4dGYdr1+WWEmsSUq5Nj+lmOk05dxD/?=
 =?us-ascii?Q?E4gPCMBSlkNXpzIjT2WdtJseP0lGK9o9rh3lyKERPXmU/RhSB1QKalodTC6J?=
 =?us-ascii?Q?grSAgRIx8LGJu+I2/MplFQlC/Hp3FDOGEdWU0Sw0vWFmI2WYbLeAp2VjKqzh?=
 =?us-ascii?Q?SBCtDogFco4adFWoQBrmfuRvbblBBlXEIpSG/6NNZmq2u0uDKSbLNin+f9v+?=
 =?us-ascii?Q?aCKqN0CwHEEGslm2ZsQeL0BcjZzIF2qRaY8DQp3KgO2ytFV52TEuSAi0X72R?=
 =?us-ascii?Q?wVC28b8IBAzyoYa6k8h7gjFLVfjdod5XP1a8C83MeATUFsWhgOVTux7vsqah?=
 =?us-ascii?Q?AX15cKVI3rU61n3w4zGlvHnvmnMepgN3x6rE+IklhvH04NY4IKiNJ33FforF?=
 =?us-ascii?Q?YKyCYoLEfrw6Rgpd8OM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb1deb3b-6d94-4ebc-59ab-08dcbdf28813
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 12:54:14.4085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlv4R+fSoNh3GqZc7MJuQGeY4225JqnTH3QZxmt73125Vj7D6bGEl9oF2sj9GXcu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4398

On Fri, Aug 16, 2024 at 05:31:31PM +0530, Vasant Hegde wrote:
> > I see. So AMD side also has a gap. Is it easy to make it suit Jason's
> > suggestion in the above?
> 
> We can do that. We can enable ATS, PRI and PASID capability during probe time
> and keep it enabled always.

I don't see a downside to enabling PASID at probe time, it exists to
handshake with the device if the root complex is able to understand
PASID TLPs.

SMMU3 calls 
 arm_smmu_probe_device
  arm_smmu_enable_pasid
   pci_enable_pasid

So it looks Ok

Jason

