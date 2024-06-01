Return-Path: <kvm+bounces-18580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 026548D71D1
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 22:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5EB1282178
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 20:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994F0154C04;
	Sat,  1 Jun 2024 20:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gdF87KPC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D0F18AEA;
	Sat,  1 Jun 2024 20:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717274457; cv=fail; b=igg4VNfSzMC8pea9sbS6bj2SxaMqG7IT7ELV3vaiYjlZOXcNrPfOXCHeoaTQ2GrybyheYMzIhp6u/MD+x7MVgKKziQhs+tkJYShU5sNdq8hvzhK5eJLbVQFdk1Fq8M9zn0U32JSBvLhbxeAzEXvGhVzAtNS1bzwqwBy34d36l/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717274457; c=relaxed/simple;
	bh=QQLHFPL9uOsQe3fjyFoHRNLu0qCvjsC0WymP6PzT2xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=alpOeq8Ealhuwg7R960RLudaAQ7dHqfGzgEctHtpk6H5cYNfpUE3K4gXm8tXNC3XNykJZb2rEFWrKpP49VKqLC9Dcbi/xnFLGXFHJCp6KUIqdNp3eWBuS+2qqwd6nhyz/6m10/p23a3S8gQ0ykNvXnkOZacE3QSlgpPSWAmLcpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gdF87KPC; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJJo8uoprVsjWxWU74NtmD993ElS4Rss9gN9hsEGjUIbRAliCQlFxbiO5qwxyVM81SFbt6rDN/SSI9HxNP0qVfDvVFbQs2pHP2yNpGpFgvHFJEe6ZXJ9GJxyI5/xsoFHGA+OxpuPFd4KDTOxXf5v9jkiryVqkMN5J4XnJD6qW5PLj849tFcFShh8QivM/Fgl+W6nwWjK71rwldBFSZC0pl5ctmo5Ec4HaXG7aMOPlY+pxUWRYyfgaKDFrXKJLnncpnQpKS9SqgGLJmoDjYsNB1OUfMk9M0kzEh4PBr2X0eJ8Bqkt47xDT0zDIsCi9NMd2Kvz8YLEIv9Q4oMDU0DrsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQLHFPL9uOsQe3fjyFoHRNLu0qCvjsC0WymP6PzT2xs=;
 b=PDBVpmETiQRQUMVVjOOlEesMGYrd+uIh9ZfBAHVLuotsgZIe54l0ZlwV8u5DbkCD6atYHEzOnl8YGYkBS49er/WSEsteX4hUvKMEHq/+umQ6Zdtad6qN121slTEMV5cCM2YztrKn9Mb6Iv2PASppovcCUHV9snMdef+s9PHAmp6bFM9GnK84a63ACcbQHCWG2I/t0UWlg8zXsZ7CO0FWYfBL6fCOmvtNzDZNEveiIF6cjYXRi8GrPPogye+hfMw+co/28xEvFp6Kbu3ME3AqK+G6oAO/gkVVXa2yXjNP6omwQcJYkyeQn0TMk70nVqzgE4+dAOXSJNmmTNr+LbiXQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQLHFPL9uOsQe3fjyFoHRNLu0qCvjsC0WymP6PzT2xs=;
 b=gdF87KPCPZsKgO0KANl9eU+lfEN3IHA9uuz3873IZ/vZAGZ2GD7DvDhEhMdyi7HgmwveiIqNkWbkp9XH0Mr7MT5RAfcq+5k1pz3PZmvAKNDWDvK1ZG9zC/s6MiPZA03t9uQzGfw0nAS4QXyv24W4cOg0b3++stqYSeNNsw8A2Ak47uMyVjODYn6GVo8O2YvsYFHvTsRiHlrIw3SXLWKtynm7LM9WYHnVkrHFTpUaIftZ9dsGHzl7TEscamI5lGYBSGvnQR5JBLR+Dk38J5lEoNq9pmh03QKlOeCmn+HXtKoErUqrr46SPT5/plxdwLtSvQQi28KegrbLjZxF01w1nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ2PR12MB8062.namprd12.prod.outlook.com (2603:10b6:a03:4c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Sat, 1 Jun
 2024 20:40:53 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Sat, 1 Jun 2024
 20:40:51 +0000
Date: Sat, 1 Jun 2024 17:40:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Steven Price <steven.price@arm.com>
Cc: Itaru Kitayama <itaru.kitayama@linux.dev>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: Re: [v2] Support for Arm CCA VMs on Linux
Message-ID: <ZluHS9ZAZwzF85jk@nvidia.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <Zhgx1IDhEYo27OAR@vm3>
 <b2accd2c-15cc-44d9-9191-60224b797814@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2accd2c-15cc-44d9-9191-60224b797814@arm.com>
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ2PR12MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: f28d2d23-3c83-4ae0-725b-08dc827b204d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IxIQ3V3XK9zMXHjxTiJIc0nnGXHqU/jJ5CUzqM2fJswBHD09Ii+Zg3G0IsRc?=
 =?us-ascii?Q?HYeJHzguGTJQnkD+kbV+NTlfymtR+58Kjo454IfnRT7zO9hzHAu8+JaMLnx6?=
 =?us-ascii?Q?b1wEmgl+pMkSbOjimG48BRpGDDbh19esKeip+fwsiXpLObRbO1RzhRNwk3JZ?=
 =?us-ascii?Q?btDnxxZVZ6hS1BVFUv/99a6z0XFrccccYMC1bi0m8V4bt4P8eoTEh+FefwnK?=
 =?us-ascii?Q?lh3idSbkP4HFQ93EmYywfWxutbZYmxw6FNA62/KNO+w5zOcQYFedOkt5oCcI?=
 =?us-ascii?Q?zNGbIyLtHW8ZWCXDn9Xg/9bUXePitPechKCdfiLs611mbaroXNNnEW//onRI?=
 =?us-ascii?Q?1EohrDwur+eYhX3aGnoHXXCO8eG1zq00m+TSDTWdDU61JgJv4hclB25U5i5u?=
 =?us-ascii?Q?dWkJx3P06a4bIZEt4ZJJgnricBJHdZVFOcNQ7xBFrUUKd1qrFsAHIbWtAf8r?=
 =?us-ascii?Q?46deqr2iL78RaUMo5lZDf4aRUEWF4E0y6MR7dBwnOA4ffbIh83eswuOzZyur?=
 =?us-ascii?Q?ZffV5kDKvAtn1h+ip1ZuRSUhOhioNHqqIfQsyxxWTcNWJ+ahNTKn4YZp2F/A?=
 =?us-ascii?Q?CMzOiOB6Pg5IrWC6P4qQRn7N5977/ghDjoLVPVh2ypD5L4GfY9mwRfoHlVWc?=
 =?us-ascii?Q?JBonlyID19TShM53JeLHjRljfSXslEVd5Pcl10hXBSPwO7mxu2BLXOBoO5B+?=
 =?us-ascii?Q?GfoPAZr9pOwO9MvVc2JYai+FjGM0mpFtdQr1rGRG1NJ5qTB3EovhPLhEYqdD?=
 =?us-ascii?Q?Lw+Oo6P6D/q0S9j77h4W506P5w3ana+5yJIo3joScQKKXnzqbGWd4jIbLVQy?=
 =?us-ascii?Q?sKUKNCQxLxYIKxjnQ2gF6G/ngd29AW2kNquV5Oih9KHrwKBjr+w8ujMlJwcz?=
 =?us-ascii?Q?dUuIcXgkMwnqOBiPhvhqpE40Xm7TR4b+7lgvgGnjOIxFMLuEB15LPAxoE3p5?=
 =?us-ascii?Q?2D/Fda9+n+5MCNepy9pUCB9R7ZcfPxrVYck+xEc2r1IyBxoMWHVHbS5y51t0?=
 =?us-ascii?Q?mMBe5BZpZLYMRX/VxcCdSQmwEoA23SRzhqhV/nUIQiwlNQwqeaM0xZ5jLC3k?=
 =?us-ascii?Q?KEU1rOFtzpPIzScFBU8SB1ESZZHMPGMyw7aoinhsHZ4Yqbe1N78N5CIwNQ6E?=
 =?us-ascii?Q?WikjWctwtPGTEGv8e6XdNwGaZvN//Gyw5UB6s4d57W9Nuu/nCafD3YKyRXsH?=
 =?us-ascii?Q?FAMKv7YMjUL4Cl0JSBowRlU0i/RlDaEHKryqvUXzAqiGsuIoLpDw+3fRfwIA?=
 =?us-ascii?Q?FU3OXYaAYAyMCsZiQ/RFXMUSsHI9MrtrQPntKP4yHA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Aq/xDarG/7y0ZrXaz4R1xYYHYFHOjpovPSJ5CMIMB0MVeCqcNo34k112aBf9?=
 =?us-ascii?Q?ZGeD6sQP74OHClGai8vWw1+le9GiIirRg9CrJ+VFk+A7CFw8oceVMq9yVe5C?=
 =?us-ascii?Q?UqYXGh6F4Z+dwpY2aUQbjR6v4B/ICUFDoIfIUNAotIFiDo4O+6M9GPOKxwiP?=
 =?us-ascii?Q?H6vNHs8vk/ZMT2fFtG7iM/SkVSuY/6LNbXIcpAAyy9WYLEFSw9Wqv2Qr5Fw+?=
 =?us-ascii?Q?oWlYaVdJguBG+JlpNGnKC9iOJNlCAWdizbpoeVqqzgRP5c9oTiwXAuL5RqEP?=
 =?us-ascii?Q?ANg71jbJAOjY/ZQlCu7hxu4yjOAh4rAcmuh+OUQSdjwyo1QubyJ1ibtvFT/G?=
 =?us-ascii?Q?cv5ZwT8+3ioMvpeUSEmhlTmZJC5OT2EHxv6aOwkf/ZtZlZyArW2VmYlMDgHu?=
 =?us-ascii?Q?WqU3EhjTdWtR/1vz1CMwMSnWa0i2I0rZBn1ZzGoMb2iEfaYM7VVvVu220T76?=
 =?us-ascii?Q?IfHQXZbrGs36yiMggiWK4ubjQivm1bQ6aFxN+X/fw9eRAPZaxNXSVFi+52LP?=
 =?us-ascii?Q?k6u0yyZanKwEPe6ivqCRqIoeS3jT2k4H+76GdqPcD87ReWBdnbCLWLPTdabJ?=
 =?us-ascii?Q?6WQI8xliPa1tQ9hXiQ9hFOFThLA/gb2Cm8q5EeF0xaVd+D8HUMhwKZwa5L/G?=
 =?us-ascii?Q?kWH3kMmrSpFMLPYU9w5/TOBXjaenCPhLzuJnlPY342GQsxiDjGIUI56ew8d9?=
 =?us-ascii?Q?0JzvpKDPfSv5qx0bBO0ciLo2PLeyZvFsM9GzXX00jlbuNJIf1Rsz0dS5+5DR?=
 =?us-ascii?Q?YnHKNOMg1uu7X1YByL65h2x+9bB48uwPeXTG9CEPk8npLNC73zFC6l8JbGD/?=
 =?us-ascii?Q?tP+4tCRdEQdCsaPcuAXAW4r2t1czfMFysMqaATZpnOEbJlHviD5ieyv+WmCm?=
 =?us-ascii?Q?Ji/7F4ZwxWiEIF5Ur5yqAzktj3t59/Jnb9cZiUOonn9tXfTg/4uz3mkEDxYd?=
 =?us-ascii?Q?STvtCncijzEm3EXMKpKK0huDjZ6VZbZhT43xUWOy1Mf7jpfmA4AbI2g/zIuL?=
 =?us-ascii?Q?ZTSCzdFeFJUNRMWrNf+SVcRwH5YAPB93APsb3Gh3fQTBtzx5IZv/rEzQ3vtP?=
 =?us-ascii?Q?BOGSvc6pRY3j5pwtWYinbrbDmfG/PF5NK6ALS2CVyRghA6aXK/kiknUUMb/Z?=
 =?us-ascii?Q?145wSJkLRV7Xn2QW7YIfk8MTXssLjdzWjQMLJB6MPJrAbkcruMQw7HWSoYHv?=
 =?us-ascii?Q?2Iyo6CfXjnJkC5Z1cHEAHAwHjrCRxFEmZ4XTydZ7v/WNlCSe7IO+MrW1oFTW?=
 =?us-ascii?Q?ul6hY8heY5oOr9/Lf9JSPMoZEVkkibJFhRCjHDCHYVJfV65qrDv0x+XfKQ6G?=
 =?us-ascii?Q?NHwnUxQmuc1o5AEasiUG9LA4mNaQP5iCUdg2cypuxM+t7WJnXrIK7pNAFeZm?=
 =?us-ascii?Q?BVfgkpYM7u4E7uUtAYSlC0wTM57Wi6g0qCtZwE1EzSe6eP5k3v/ZDdA9YY9Y?=
 =?us-ascii?Q?q35sMCFG12Q/FWW9QL+wcseA4XHY5XRVWEF/J01ace80XFoiuH2TxD38eJ20?=
 =?us-ascii?Q?r6HRxskrKspaOgkGmSlqnKoojASQRWqMc5/19xKCE6stRFyj4ZQ9esOZTJxg?=
 =?us-ascii?Q?7kNB4gsETPKmpALFQntBANi+dXIANXg8LxlPV0Pc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f28d2d23-3c83-4ae0-725b-08dc827b204d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2024 20:40:51.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: thpu/S0ipIu+Ph+DVcHqdpLvY4U9U3j2ZCHow/4IXebHSJWsJ8tRQFYn2N1qbril
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8062

On Mon, Apr 15, 2024 at 09:14:47AM +0100, Steven Price wrote:

> The support for running in a guest is (I believe) in a good state
> and I don't expect to have to iterate much on that before merging -
> but, as always, that depends on the feedback received.

All the stuff I've been hearing about CC is that timely guest support
is a really important thing. Right now the majority of the CC world is
running on propritary hypervisors, it is the guest enablement that is
something a wide group of people will be able to actually consume and
use.

It needs to get into mainline to be able to reach distros about a year
before anyone offers an ARM CC VM to the public. Various x86 guest
only parts for CC are already merged.

The KVM side is absolutely really important as well, but x86 has
managed for a long time now with KVM being out of tree. The KVM side
is far more complex at least.

So I'd split out the guest side and just send it, I saw a few comments
already, but it looks like it shouldn't be an issue to make it this
cycle or next? Keep sending guest enablement updates when the spec is
stable and you have some way to do basic test.

Jason

