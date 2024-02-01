Return-Path: <kvm+bounces-7745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC09845D51
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:33:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F8CB1C2638E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEE8568D;
	Thu,  1 Feb 2024 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AJzsb5vz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BF617C9C;
	Thu,  1 Feb 2024 16:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706805163; cv=fail; b=f99/OenSzYbtpqRSng7D02ahuV6HrlluEIRabIeYMzmSQ/hLCvoLkbjBvYaWODG4mNMQ1u1nBf0yCCGzNyrGHlR7pqXB8bxATVnzLL+8BPnE/5OJaAd48opqXm1Cpc7yHU7kt8It5CUP9fCO8p6Y8vF9E/5ABZzyxNlPNoEN+jM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706805163; c=relaxed/simple;
	bh=WpqItaX23NXhy9lLwaSvTMvfQ4pybJUfjeMTP+6+c1Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s0iQ6jUkZaZstYLahTZ2GDnKsX+X5QR9SpTXOEC9MpiOxeyoi2YiINJEdw740ict12rwwhogWoQa8nNt99KFQIeB8vVfXobMh6c9Kxo2yxFor1WL75o9FsU8aEeq0/cGXJHGvunht3olv8eTTw/kLkyEd5q7knHKgjxDVUrnLVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AJzsb5vz; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXeaU3u+SeueAt6BFDbI3SdX1QPK/iyMGEWRD5LKuEun/5FhXXx6AI1xed32usT+X/dOB5MQ4zsTHwz/k1XzA62u+INLltMnE8ptLoZDgUukE5SH+g+qoNAJaf74FEt18gzhyyDUJRXNSmKJ/ch6ctwdC09AcurLRGa58KNbtOmHGdlWCv1tbXTqcXBaXlywipLplYZadOIxNyFuuupRk8RtHDosI8KW61l11axa3EnLZsclACA2E9Z872nkTKv9nDYOvfdY4C7NzNe4NlJdxWwVH5MXeg6W60+9sphbiUXGd4LdAngHs9aSedaASl1aPl+VoIb47SOu8dQxcHMe8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMyQ7Qnu/P17efYdtrAJjAnI0tVR5LF5BZKaVI4mBRs=;
 b=Uw63NuBjC2Nrde9oWJMctDoOh7GZPuATSEeV7DEnIg2imoBQGjHYYddn7/gMNuJQkFSzUxz8AqLLdXHIu7Qr9I1l/1+w+CF1dT83hn8nF7IpiAeIntYI1e9mROjO9TdtBd9njly7ydVJ2UqsSgmFkOnu5cMCZsosoH5093mV/l5xyY9ecdQkOFz0cFttdJzXbAP5BGy0Z2/QGE0EHhCMyoPBTZ61otRL87HUfT2MU1B62uISN9AFpYtw5Ju8tNFuXrseMQDETvg8Ai9RA7pa1P9l0jYMMHBO9bPm8vK5UDD8mArT13UQxbGp5IediLTajztDIhFtXPj8pMGAFM3Omw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMyQ7Qnu/P17efYdtrAJjAnI0tVR5LF5BZKaVI4mBRs=;
 b=AJzsb5vznHsD1Qy0AZuXkMAtBACMepjgvAjrER/0hPW4+rUkPvOnsWr57SUcEzH8xZzHAfAQjZqjFYJ5el7Mp9Ex7qIakHFfCWIaXvBWhdYAgvgWpQo46Ud2p2qphyOU8ZymbK7XTjzg2875vJ1D9BPEmZpyNBkSE4dIGEEXZBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW3PR12MB4490.namprd12.prod.outlook.com (2603:10b6:303:2f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.11; Thu, 1 Feb
 2024 16:32:39 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::200:c1d0:b9aa:e16c%4]) with mapi id 15.20.7270.009; Thu, 1 Feb 2024
 16:32:39 +0000
Message-ID: <41b47702-6e65-439c-aa0d-bf47647e33c6@amd.com>
Date: Thu, 1 Feb 2024 10:32:37 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] KVM: SVM: Return -EINVAL instead of -EBUSY on
 attempt to re-init SEV/SEV-ES
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>
References: <20240131235609.4161407-1-seanjc@google.com>
 <20240131235609.4161407-5-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 xsFNBFaNZYkBEADxg5OW/ajpUG7zgnUQPsMqWPjeAxtu4YH3lCUjWWcbUgc2qDGAijsLTFv1
 kEbaJdblwYs28z3chM7QkfCGMSM29JWR1fSwPH18WyAA84YtxfPD8bfb1Exwo0CRw1RLRScn
 6aJhsZJFLKyVeaPO1eequEsFQurRhLyAfgaH9iazmOVZZmxsGiNRJkQv4YnM2rZYi+4vWnxN
 1ebHf4S1puN0xzQsULhG3rUyV2uIsqBFtlxZ8/r9MwOJ2mvyTXHzHdJBViOalZAUo7VFt3Fb
 aNkR5OR65eTL0ViQiRgFfPDBgkFCSlaxZvc7qSOcrhol160bK87qn0SbYLfplwiXZY/b/+ez
 0zBtIt+uhZJ38HnOLWdda/8kuLX3qhGL5aNz1AeqcE5TW4D8v9ndYeAXFhQI7kbOhr0ruUpA
 udREH98EmVJsADuq0RBcIEkojnme4wVDoFt1EG93YOnqMuif76YGEl3iv9tYcESEeLNruDN6
 LDbE8blkR3151tdg8IkgREJ+dK+q0p9UsGfdd+H7pni6Jjcxz8mjKCx6wAuzvArA0Ciq+Scg
 hfIgoiYQegZjh2vF2lCUzWWatXJoy7IzeAB5LDl/E9vz72cVD8CwQZoEx4PCsHslVpW6A/6U
 NRAz6ShU77jkoYoI4hoGC7qZcwy84mmJqRygFnb8dOjHI1KxqQARAQABzSZUb20gTGVuZGFj
 a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPsLBmQQTAQoAQwIbIwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmWDAegFCRKq1F8ACgkQ
 3v+a5E8wTVOG3xAAlLuT7f6oj+Wud8dbYCeZhEX6OLfyXpZgvFoxDu62OLGxwVGX3j5SMk0w
 IXiJRjde3pW+Rf1QWi/rbHoaIjbjmSGXvwGw3Gikj/FWb02cqTIOxSdqf7fYJGVzl2dfsAuj
 aW1Aqt61VhuKEoHzIj8hAanlwg2PW+MpB2iQ9F8Z6UShjx1PZ1rVsDAZ6JdJiG1G/UBJGHmV
 kS1G70ZqrqhA/HZ+nHgDoUXNqtZEBc9cZA9OGNWGuP9ao9b+bkyBqnn5Nj+n4jizT0gNMwVQ
 h5ZYwW/T6MjA9cchOEWXxYlcsaBstW7H7RZCjz4vlH4HgGRRIpmgz29Ezg78ffBj2q+eBe01
 7AuNwla7igb0mk2GdwbygunAH1lGA6CTPBlvt4JMBrtretK1a4guruUL9EiFV2xt6ls7/YXP
 3/LJl9iPk8eP44RlNHudPS9sp7BiqdrzkrG1CCMBE67mf1QWaRFTUDPiIIhrazpmEtEjFLqP
 r0P7OC7mH/yWQHvBc1S8n+WoiPjM/HPKRQ4qGX1T2IKW6VJ/f+cccDTzjsrIXTUdW5OSKvCG
 6p1EFFxSHqxTuk3CQ8TSzs0ShaSZnqO1LBU7bMMB1blHy9msrzx7QCLTw6zBfP+TpPANmfVJ
 mHJcT3FRPk+9MrnvCMYmlJ95/5EIuA1nlqezimrwCdc5Y5qGBbbOwU0EVo1liQEQAL7ybY01
 hvEg6pOh2G1Q+/ZWmyii8xhQ0sPjvEXWb5MWvIh7RxD9V5Zv144EtbIABtR0Tws7xDObe7bb
 r9nlSxZPur+JDsFmtywgkd778G0nDt3i7szqzcQPOcR03U7XPDTBJXDpNwVV+L8xvx5gsr2I
 bhiBQd9iX8kap5k3I6wfBSZm1ZgWGQb2mbiuqODPzfzNdKr/MCtxWEsWOAf/ClFcyr+c/Eh2
 +gXgC5Keh2ZIb/xO+1CrTC3Sg9l9Hs5DG3CplCbVKWmaL1y7mdCiSt2b/dXE0K1nJR9ZyRGO
 lfwZw1aFPHT+Ay5p6rZGzadvu7ypBoTwp62R1o456js7CyIg81O61ojiDXLUGxZN/BEYNDC9
 n9q1PyfMrD42LtvOP6ZRtBeSPEH5G/5pIt4FVit0Y4wTrpG7mjBM06kHd6V+pflB8GRxTq5M
 7mzLFjILUl9/BJjzYBzesspbeoT/G7e5JqbiLWXFYOeg6XJ/iOCMLdd9RL46JXYJsBZnjZD8
 Rn6KVO7pqs5J9K/nJDVyCdf8JnYD5Rq6OOmgP/zDnbSUSOZWrHQWQ8v3Ef665jpoXNq+Zyob
 pfbeihuWfBhprWUk0P/m+cnR2qeE4yXYl4qCcWAkRyGRu2zgIwXAOXCHTqy9TW10LGq1+04+
 LmJHwpAABSLtr7Jgh4erWXi9mFoRABEBAAHCwXwEGAEKACYCGwwWIQTdWKXnw4wULDeIG/Xe
 /5rkTzBNUwUCZYMCBQUJEqrUfAAKCRDe/5rkTzBNU7pAD/9MUrEGaaiZkyPSs/5Ax6PNmolD
 h0+Q8Sl4Hwve42Kjky2GYXTjxW8vP9pxtk+OAN5wrbktZb3HE61TyyniPQ5V37jto8mgdslC
 zZsMMm2WIm9hvNEvTk/GW+hEvKmgUS5J6z+R5mXOeP/vX8IJNpiWsc7X1NlJghFq3A6Qas49
 CT81ua7/EujW17odx5XPXyTfpPs+/dq/3eR3tJ06DNxnQfh7FdyveWWpxb/S2IhWRTI+eGVD
 ah54YVJcD6lUdyYB/D4Byu4HVrDtvVGUS1diRUOtDP2dBJybc7sZWaIXotfkUkZDzIM2m95K
 oczeBoBdOQtoHTJsFRqOfC9x4S+zd0hXklViBNQb97ZXoHtOyrGSiUCNXTHmG+4Rs7Oo0Dh1
 UUlukWFxh5vFKSjr4uVuYk7mcx80rAheB9sz7zRWyBfTqCinTrgqG6HndNa0oTcqNI9mDjJr
 NdQdtvYxECabwtPaShqnRIE7HhQPu8Xr9adirnDw1Wruafmyxnn5W3rhJy06etmP0pzL6frN
 y46PmDPicLjX/srgemvLtHoeVRplL9ATAkmQ7yxXc6wBSwf1BYs9gAiwXbU1vMod0AXXRBym
 0qhojoaSdRP5XTShfvOYdDozraaKx5Wx8X+oZvvjbbHhHGPL2seq97fp3nZ9h8TIQXRhO+aY
 vFkWitqCJg==
In-Reply-To: <20240131235609.4161407-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0101.namprd11.prod.outlook.com
 (2603:10b6:806:d1::16) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW3PR12MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: c9ecc916-403d-41a2-c952-08dc234367e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A5yiCdcGybVxqF6mpdTt3qWCC5/QbextotvoVDbHwBr6/fNM9tIUc916bjY1n1UgiezqVIdK5pXdbtw5JGn4Xkq6mKyXOchvROP2s+PVO4Vg00tFy79wUMd4MgPHnRwxF+hOdtndkmlyBg1oav7dQgQGfecZ/c7kZXNVCkBcYEVG4lX2SpiJZkAHrjW4petOePsNNhSoM7G4NjPvrvEx7OsO8BySXUQZJ0xsTY4ygR7k6If37F98eWfFQoyzfQ3wgU/rMidNZamv6UTvLhxW+Sx8emmT58u10fnnxAECrVyuqn7C9mFEszJU3vzBtun7HPcXONaa2Ig7++T9/kKpFcUIBsrUNPMvIcQTYD3jU3uTd0bGQGXjy5jCjdNYzQLGMNtp9Iz7RBWaX0IJ3u4yaH1xu3QiOQ8wvcX1A52XnC6k7ckwYKUjel2mlUekMnu+1Fq3bjH8QxPP8XDdFWmonEhiyjKRqg4GAdq6G+HmW2TcFS2QHmQOuwoYpH8C5D2HBrNZvDTZoy+Bumhph1dwjM70f26aOhAasJufKwc++QNzj+rxQSUbVPvqc1i6vptIFwcmO4huwDOz2/l747qV6dszq0SV66UVtfzRtxaeWNcTdwKHWkO3GxdEeG0qme+pudFNtaurRsEt3BavG6VPzw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(346002)(396003)(376002)(39860400002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(2906002)(31686004)(478600001)(5660300002)(83380400001)(66946007)(6512007)(66476007)(110136005)(8936002)(8676002)(316002)(36756003)(66556008)(4326008)(31696002)(6486002)(6506007)(86362001)(53546011)(41300700001)(2616005)(38100700002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFhCK2UrS2NrOU5HTlJ6Z2FwVDc2aHEvaTRiRjMzcm9wQ0Y2Zmk3OHJjTnRD?=
 =?utf-8?B?d0ptSDJGVWJ4TW9wY3haUDAzb3QybGpyMlhJMXIwR1lPUFRkRUZpNjdmM3h4?=
 =?utf-8?B?R0ZJdCs3bjVCWVJwSFd6K1dqMkNpVFJ0QzR3aHVZY05ESmFVTEpkclIwSzQr?=
 =?utf-8?B?U3pVdGZ5WGFBL3RObXFVSTFLWFk5bVROczJwZENPYy9CS1JrMjZFdUNpVDJj?=
 =?utf-8?B?T0VEOFl6SnhndFpGbEdGNURYVXd4TUxCd0ExMmlsd3FsemQ1LzB4T284THZX?=
 =?utf-8?B?bnJYRWwzekQyV0JKNWh4bGdUcjRuTFBuK1cyY0kva0NZT3pTdFRzMXYzSW1R?=
 =?utf-8?B?MkZTRFZGUGV1d2FyVjZJMVJyUkVDZTBlQUh2UW9JMm9Gd1lEeVNQcWlqWG50?=
 =?utf-8?B?NXA3M0Q2SnhrYUZDUnFvM0owQi9EcDFLNlBiZ2tEVUk4aHloS3dWSGRQS2FU?=
 =?utf-8?B?RDRQaDNUclllSGFjbWNTcWhJYlhZOERlQVdEdGxPKzVqVzgzVlNSeThUNy90?=
 =?utf-8?B?amFsZzBub01HTUZyeTlFZVlNNHhpeEtUNWZCSHBrSThRNHlVMmpMZmoxVjE0?=
 =?utf-8?B?M0VBMVhWZ1RlWFYva0dUV1BpM3dYRjExZ0hiQU13QW1xY3RycWlBaWFDREdu?=
 =?utf-8?B?VmU3U2xJNzNPdU1HRGVLbjNSMGJBVmxQQ09tQXRKUGYzTUpRRlA0SjB2c2dx?=
 =?utf-8?B?d2NNdS85UDRzaFhYckVRMWRSY0d2TEJGR0JVRlNiSlBzaGFYbSs0ZkFndkgy?=
 =?utf-8?B?OWQxREk3eVY1RnJ5WXpXSmdBclpOWUhIRUd0OHFKaWR5SUlaMVc5RlJWa3Mv?=
 =?utf-8?B?cXNRUzBoOVh2c3l4aTRVZjFJLzVYakxlditKSEJrZGNWWFZweVVCOGFidkRE?=
 =?utf-8?B?NGVORW1OcUoreXR1NzRCaFl4eGpGcHYxaFFUeGNXZUVaYjhJQTlQN0RvcDBM?=
 =?utf-8?B?YVhVWDIzNFZCdmY4Qi9UYzNJS2ZVckNwTVplNENPUjZ3SWl5NzBkMHZFclAv?=
 =?utf-8?B?T0tQV0Z5bzE1aENrVHJNOERPRlE0SE9KSEI3akwvQWxJdUJrVHhXaStOb0Z0?=
 =?utf-8?B?a0ZRQ1g2OUZtdFIveWE0SC9zNzFDMjNub0JTMFRJbHFNNjZnTXd1bnUxemNx?=
 =?utf-8?B?aXFKNEdGcy9laDBRdi9KaWs3MWlySy9RSExkWDZ4ZFBGMWpzSzVQeFlpMHhL?=
 =?utf-8?B?OFRQMHlKZDAzeUR5ZHVqZVVsU2l6OFcvUUxzQm5keEF3QlFlVkxGNU1ydDA1?=
 =?utf-8?B?YnlOU0pUYUp4cUwxWFdkbTFSckk5OFo0d2tlYktuVm1NSjQzbk5KNC9FUlpq?=
 =?utf-8?B?czdOSHd4WHNRbStudnhabXlEUVJVUHprblhXRjhLbmF4UnkvQW95engwWXNw?=
 =?utf-8?B?cGhQM3JQaHNrdUhWeUJTUmZVMkFDOXB0cmFCR3pPQmpySlVCOSsvcTc2Rlly?=
 =?utf-8?B?Q1dsVGo2TkF4N1hlbkhjVVhaTHF0aEtSTVZ3TlJub3QyaElEdVpZU204WjZT?=
 =?utf-8?B?S1RNQ2hlSGdYbHZJZGRNcHRmZmZBYXlaMExhYUs2WnJwV2Y1U0pnN1ZSMFVM?=
 =?utf-8?B?WFpQUXRuNTJ5Q0xDS0RQWkdPYnFIdDZoRmVxUW5jdlluTC9KWDlqUnRLeHZ4?=
 =?utf-8?B?RmladVVYNnAxcDRvVzhyZzF2bUpOMFhadHRBM3ZuTHhiV3FSZWc5ZDBDc2Vy?=
 =?utf-8?B?QUV1dHE3OTJRQ0JGNXFPVzBPdmovVnR3bmFHTHpWYzdrZ3hQOFF5eUh5bXRs?=
 =?utf-8?B?WmdQT0ZrSkV5NndiU084SW1QZDB4MWNWQ0REWHBoR05xZnpjb2VMVisvQ3hB?=
 =?utf-8?B?b2hnZDVHR2VrL2V1ckkxbTY1ZURyam9lQ0J5ZjV5RnRVQnBCTFVTOHhsK0N4?=
 =?utf-8?B?WUtLQnc0dFV1MmIzdUxLek8rdEphR1c1UkhuRFF2cTdycTFMaXdWT2FNQ2Rl?=
 =?utf-8?B?d0N1ZWExNnBHdGxDK1dkdTVZeXp1OENjVXhjWEw3MWZab1FvRGowaHZaMU56?=
 =?utf-8?B?QjFnMlF0RWFmTDVYSHBVUktSRkNQcmE2dVoxRS80akJIQTBZUXZhaDNhUnoz?=
 =?utf-8?B?ZVZtYzdsVUx1QkhxOGxLOFF6azRpalFuZHpmMGQ0UlRuVGZQSmZYS0pIVnFk?=
 =?utf-8?Q?0BFOnTsfOljrk6hMwZyYYU0Yp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9ecc916-403d-41a2-c952-08dc234367e5
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 16:32:39.4027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vYnv6xwH4r433LV+NaEhM8bRYUCMM2G/oLqA2isyo5kPS9oFycWUgwRjuFtuMx8Zn7Vfsith8PSE+8xYqRnxpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4490

On 1/31/24 17:56, Sean Christopherson wrote:
> Return -EINVAL instead of -EBUSY if userspace attempts KVM_SEV{,ES}_INIT
> on a VM that already has SEV active.  Returning -EBUSY is nonsencial as
> it's impossible to deactivate SEV without destroying the VM, i.e. the VM
> isn't "busy" in any sane sense of the word, and the odds of any userspace
> wanting exactly -EBUSY on a userspace bug are minuscule.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 38e40fbc7ea0..cb19b57e1031 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -259,9 +259,8 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>   	if (kvm->created_vcpus)
>   		return -EINVAL;
>   
> -	ret = -EBUSY;
>   	if (unlikely(sev->active))
> -		return ret;
> +		return -EINVAL;
>   
>   	sev->active = true;
>   	sev->es_active = argp->id == KVM_SEV_ES_INIT;

